struct AnyEncodable: Encodable {
    let encodeValue: (Encoder) throws -> Void

    init<T: Encodable> (storing value: T) {
        encodeValue = value.encode
    }

    func encode (to encoder: Encoder) throws {
        try encodeValue(encoder)
    }
}

func wrapAny (_ content: [String: Any], prefix: String = EMPTY_STRING, separator: String = UNDERSCORE, uppercase: Bool = true, lowercase: Bool = false) throws -> AnyEncodable {
    var wrappedContent: [String: AnyEncodable] = [:]

    let prefixWithSeparator = prefix == EMPTY_STRING ? prefix : prefix + separator

    for (key, value) in content.sorted(by: { $0.key < $1.key }) {
        let uppercasedKey = uppercase ? key.uppercased() : lowercase ? key.lowercased() : key
        let nextPrefix = "\(prefixWithSeparator)\(uppercasedKey)"

        if let _ = value as? String {
            wrappedContent[key] = AnyEncodable(storing: "process.env.\(nextPrefix)")
        } else if let _ = value as? [String] {
            wrappedContent[key] = AnyEncodable(storing: "process.env.\(nextPrefix)")
        } else if let valueAsMap = value as? [String: Any] {
            wrappedContent[key] = try wrapAny(valueAsMap, prefix: nextPrefix, separator: separator, uppercase: uppercase, lowercase: lowercase)
        } else {
            throw ConfigReaderSerializationError.cannotSerialize(value: "\(value)")
        }
    }

    return AnyEncodable(storing: wrappedContent)
}

