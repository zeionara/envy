func serializeConfig (content: [String: Any], prefix: String = EMPTY_STRING, separator: String = UNDERSCORE, uppercase: Bool = true, lowercase: Bool = false) throws -> [String] {
    var lines: [String] = []

    let prefixWithSeparator = prefix == EMPTY_STRING ? prefix : prefix + separator
    var isFirstKey = prefix == EMPTY_STRING

    for (key, value) in content.sorted(by: { $0.key < $1.key }) {
        let uppercasedKey = uppercase ? key.uppercased() : lowercase ? key.lowercased() : key

        if (isFirstKey) {
            isFirstKey = false
        } else if (prefix == EMPTY_STRING) {
            lines.append(EMPTY_STRING)
        }

        if let valueAsString = value as? String {
            lines.append("\(prefixWithSeparator)\(uppercasedKey)=\(valueAsString)")
        } else if let valueAsNumeric = value as? any Numeric {
            lines.append("\(prefixWithSeparator)\(uppercasedKey)=\(valueAsNumeric)")
        } else if let valueAsArrayOfStrings = value as? [String] {
            lines.append("\(prefixWithSeparator)\(uppercasedKey)=\(valueAsArrayOfStrings.joined(separator: COMMA))")
        } else if let valueAsArrayOfNumerics = value as? [any Numeric] {
            lines.append("\(prefixWithSeparator)\(uppercasedKey)=\(valueAsArrayOfNumerics.map{ "\($0)" }.joined(separator: COMMA))")
        } else if let valueAsMap = value as? [String: Any] {
            lines.append(contentsOf: try serializeConfig(content: valueAsMap, prefix: "\(prefixWithSeparator)\(uppercasedKey)", separator: separator, uppercase: uppercase, lowercase: lowercase))
        } else {
            throw ConfigSerializationError.cannotSerialize(value: "\(value)")
        }

    }

    return lines
}
