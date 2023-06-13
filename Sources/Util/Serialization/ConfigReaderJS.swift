import Foundation

func wrapConfigReaderJS (
    _ content: [String: Any], prefix: String = EMPTY_STRING,
    keySeparator: String = UNDERSCORE, keyPartSeparator: String = DASH, keyPartSeparatorReplacement: String = UNDERSCORE,
    uppercase: Bool = true, lowercase: Bool = false
) throws -> [String: Any] {
    var wrappedContent: [String: Any] = [:]

    let prefixWithSeparator = prefix == EMPTY_STRING ? prefix : prefix + keySeparator

    for (key, value) in content.sorted(by: { $0.key < $1.key }) {
        var uppercasedKey = uppercase ? key.uppercased() : lowercase ? key.lowercased() : key
        let keyCamelCased = try key.camelCased

        if (keyPartSeparator != keyPartSeparatorReplacement) {
            uppercasedKey = uppercasedKey.replacingOccurrences(of: keyPartSeparator, with: keyPartSeparatorReplacement)
        }

        let nextPrefix = "\(prefixWithSeparator)\(uppercasedKey)"

        do {
            try stringEncoder.encodeConfigReaderProperty(key: keyCamelCased, env: nextPrefix, value: value, content: &wrappedContent)
        } catch ConfigEncodingError.unsupportedValueScheme {
            do {
                try numericEncoder.encodeConfigReaderProperty(key: keyCamelCased, env: nextPrefix, value: value, content: &wrappedContent)
            } catch ConfigEncodingError.unsupportedValueScheme {
                if let _ = value as? [String] {
                    wrappedContent[keyCamelCased] = "process.env.\(nextPrefix)"
                } else if let _ = value as? [any Numeric] {
                    wrappedContent[keyCamelCased] = "process.env.\(nextPrefix)"
                } else if let valueAsArrayOfObjects = value as? [[String: Any]] {
                    let nMaxPaddingZeros = Int(ceil(log(Double(valueAsArrayOfObjects.count))/log(10)))

                    wrappedContent[keyCamelCased] = try valueAsArrayOfObjects.enumerated().map{ i, object in
                        try wrapConfigReaderJS(
                            object, prefix: "\(nextPrefix)\(keySeparator)\(String(format: "%0\(nMaxPaddingZeros)d", i))",
                            keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: keyPartSeparatorReplacement,
                            uppercase: uppercase, lowercase: lowercase
                        )
                    }
                } else if let valueAsMap = value as? [String: Any] {
                    wrappedContent[keyCamelCased] = try wrapConfigReaderJS(
                        valueAsMap, prefix: nextPrefix,
                        keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: keyPartSeparatorReplacement,
                        uppercase: uppercase, lowercase: lowercase
                    )
                } else {
                    throw ConfigReaderSerializationError.cannotSerialize(value: "\(value)")
                }
            }
        }
    }

    return wrappedContent
}
