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

let stringEncoder = StringConfigEncoder()
let numericEncoder = NumericConfigEncoder()

func serializeConfig (
    content: [String: Any], prefix: String = EMPTY_STRING,
    keySeparator: String = UNDERSCORE, keyPartSeparator: String = DASH, keyPartSeparatorReplacement: String = UNDERSCORE,
    // separator: String = UNDERSCORE, long_separator: String = DOUBLE_UNDERSCORE, dash_replacement: String = UNDERSCORE,
    uppercase: Bool = true, lowercase: Bool = false
) throws -> [String] {
    var lines: [String] = []

    let isRootCall = prefix == EMPTY_STRING

    let prefixWithSeparator = isRootCall ? prefix : prefix + keySeparator
    var isFirstKey = isRootCall

    for (key, value) in content.sorted(by: { $0.key < $1.key }) {
        var uppercasedKey: String = uppercase ? key.uppercased() : lowercase ? key.lowercased() : key

        if (keyPartSeparator != keyPartSeparatorReplacement) {
            uppercasedKey = uppercasedKey.replacingOccurrences(of: keyPartSeparator, with: keyPartSeparatorReplacement)
        }

        if (isFirstKey) {
            isFirstKey = false
        } else if (prefix == EMPTY_STRING) {
            lines.append(EMPTY_STRING)
        }

        // if let valueAsString = value as? String {
        //     lines.append("\(prefixWithSeparator)\(uppercasedKey)=\(valueAsString)")
        // } else

        let env = "\(prefixWithSeparator)\(uppercasedKey)"

        do {
            try stringEncoder.encodeConfigProperty(env: env, value: value, lines: &lines)
        } catch ConfigEncodingError.unsupportedValueScheme {
            do {
                try numericEncoder.encodeConfigProperty(env: env, value: value, lines: &lines)
            } catch ConfigEncodingError.unsupportedValueScheme {
                if let valueAsArrayOfStrings = value as? [String] {
                    lines.append("\(prefixWithSeparator)\(uppercasedKey)=\(valueAsArrayOfStrings.joined(separator: COMMA))")
                } else if let valueAsArrayOfNumerics = value as? [any Numeric] {
                    lines.append("\(prefixWithSeparator)\(uppercasedKey)=\(valueAsArrayOfNumerics.map{ "\($0)" }.joined(separator: COMMA))")
                } else if let valueAsArrayOfObjects = value as? [[String: Any]] {
                    let nMaxPaddingZeros = Int(ceil(log(Double(valueAsArrayOfObjects.count))/log(10)))

                    for (i, object) in valueAsArrayOfObjects.enumerated() {
                        lines.append(
                            contentsOf: try serializeConfig(
                                content: object, prefix: "\(prefixWithSeparator)\(uppercasedKey)\(keySeparator)\(String(format: "%0\(nMaxPaddingZeros)d", i))",
                                keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: keyPartSeparatorReplacement,
                                // separator: , long_separator: long_separator, dash_replacement: dash_replacement,
                                uppercase: uppercase, lowercase: lowercase
                            )
                        )
                    }
                } else if let valueAsMap = value as? [String: Any] {
                    lines.append(
                        contentsOf: try serializeConfig(
                            content: valueAsMap, prefix: "\(prefixWithSeparator)\(uppercasedKey)",
                            keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: keyPartSeparatorReplacement,
                            // separator: fixedSeparator, long_separator: long_separator, dash_replacement: dash_replacement,
                            uppercase: uppercase, lowercase: lowercase
                        )
                    )
                } else {
                    throw ConfigSerializationError.cannotSerialize(value: "\(value)")
                }
            }
        }
    }

    return lines
}
