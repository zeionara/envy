func wrapConfigReaderJS (_ content: [String: Any], prefix: String = EMPTY_STRING, separator: String = UNDERSCORE, uppercase: Bool = true, lowercase: Bool = false) throws -> [String: Any] {
    var wrappedContent: [String: Any] = [:]

    let prefixWithSeparator = prefix == EMPTY_STRING ? prefix : prefix + separator

    for (key, value) in content.sorted(by: { $0.key < $1.key }) {
        let uppercasedKey = uppercase ? key.uppercased() : lowercase ? key.lowercased() : key
        let nextPrefix = "\(prefixWithSeparator)\(uppercasedKey)"

        if let _ = value as? String {
            wrappedContent[key] = "process.env.\(nextPrefix)"
        } else if let _ = value as? any Numeric {
            wrappedContent[key] = "process.env.\(nextPrefix)"
        } else if let _ = value as? [String] {
            wrappedContent[key] = "process.env.\(nextPrefix)"
        } else if let _ = value as? [any Numeric] {
            wrappedContent[key] = "process.env.\(nextPrefix)"
        } else if let valueAsMap = value as? [String: Any] {
            wrappedContent[key] = try wrapConfigReaderJS(valueAsMap, prefix: nextPrefix, separator: separator, uppercase: uppercase, lowercase: lowercase)
        } else {
            throw ConfigReaderSerializationError.cannotSerialize(value: "\(value)")
        }
    }

    return wrappedContent
}
