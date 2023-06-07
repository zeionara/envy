import Foundation

func hasMultipartKeys (within content: [String: Any], separator: String = DASH) -> Bool {
    for (key, value) in content {
        if (key.contains(separator)) {
            return true
        }
        if let value = value as? [String: Any] {
            if (hasMultipartKeys(within: value, separator: separator)) {
                return true
            }
        }
    }

    return false
}

func serializeConfig (
    content: [String: Any], prefix: String = EMPTY_STRING,
    separator: String = UNDERSCORE, long_separator: String = DOUBLE_UNDERSCORE, dash_replacement: String = UNDERSCORE,
    uppercase: Bool = true, lowercase: Bool = false
) throws -> [String] {
    var lines: [String] = []

    let isRootCall = prefix == EMPTY_STRING

    let fixedSeparator = isRootCall ? separator : hasMultipartKeys(within: content) ? long_separator : separator

    let prefixWithSeparator = isRootCall ? prefix : prefix + fixedSeparator
    var isFirstKey = isRootCall

    for (key, value) in content.sorted(by: { $0.key < $1.key }) {
        let uppercasedKey = (uppercase ? key.uppercased() : lowercase ? key.lowercased() : key).replacingOccurrences(of: DASH, with: dash_replacement)

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
        } else if let valueAsArrayOfObjects = value as? [[String: Any]] {
            let nMaxPaddingZeros = Int(ceil(log(Double(valueAsArrayOfObjects.count))/log(10)))

            for (i, object) in valueAsArrayOfObjects.enumerated() {
                lines.append(
                    contentsOf: try serializeConfig(
                        content: object, prefix: "\(prefixWithSeparator)\(uppercasedKey)\(fixedSeparator)\(String(format: "%0\(nMaxPaddingZeros)d", i))",
                        separator: fixedSeparator, long_separator: long_separator, dash_replacement: dash_replacement,
                        uppercase: uppercase, lowercase: lowercase
                    )
                )
            }
        } else if let valueAsMap = value as? [String: Any] {
            lines.append(
                contentsOf: try serializeConfig(
                    content: valueAsMap, prefix: "\(prefixWithSeparator)\(uppercasedKey)",
                    separator: fixedSeparator, long_separator: long_separator, dash_replacement: dash_replacement,
                    uppercase: uppercase, lowercase: lowercase
                )
            )
        } else {
            throw ConfigSerializationError.cannotSerialize(value: "\(value)")
        }

    }

    return lines
}
