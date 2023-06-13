class ObjectConfigEncoder: EnvOnlyConfigReaderProperty, BasicConfigPropertyEncoder {
    typealias ValueType = [String: Any]

    let keySeparator: String
    let keyPartSeparator: String
    let keyPartSeparatorReplacement: String

    let uppercase: Bool
    let lowercase: Bool

    var encoders: [any ConfigEncoder]

    init (encoders: [any ConfigEncoder], keySeparator: String, keyPartSeparator: String, keyPartSeparatorReplacement: String, uppercase: Bool, lowercase: Bool) {
        self.keySeparator = keySeparator
        self.keyPartSeparator = keyPartSeparator
        self.keyPartSeparatorReplacement = keyPartSeparatorReplacement
        
        self.uppercase = uppercase
        self.lowercase = lowercase

        self.encoders = []
        self.encoders.append(contentsOf: encoders)
    }

    convenience init (keySeparator: String, keyPartSeparator: String, keyPartSeparatorReplacement: String, uppercase: Bool, lowercase: Bool) {
        self.init (
            encoders: [
                StringConfigEncoder(), NumericConfigEncoder(), StringArrayConfigEncoder(), NumericArrayConfigEncoder(),
            ],
            keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: keyPartSeparatorReplacement, uppercase: uppercase, lowercase: lowercase
        )
        self.encoders.append(
            ObjectArrayConfigEncoder(
                keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: keyPartSeparatorReplacement, uppercase: uppercase, lowercase: lowercase,
                objectEncoder: self
            )
        )
        self.encoders.append(self)
    }

    func encodeConfigProperty(env: String, value: Any, lines: inout [String]) throws {
        let isRootCall = env == ""

        let prefix = isRootCall ? env : "\(env)\(keySeparator)"

        var isFirstKey = isRootCall

        for (key, value) in try encodeConfigProperty(value).sorted(by: { $0.key < $1.key }) {
            var casedKey = uppercase ? key.uppercased() : lowercase ? key.lowercased() : key

            if (keyPartSeparator != keySeparator) {
                casedKey = casedKey.replacingOccurrences(of: keyPartSeparator, with: keyPartSeparatorReplacement)
            }

            if (isFirstKey) {
                isFirstKey = false
            } else if isRootCall {
                lines.append(EMPTY_STRING)
            }

            let nextPrefix = "\(prefix)\(casedKey)"

            var encoded = false

            for encoder in encoders {
                if let _ = try? encoder.encodeConfigProperty(env: nextPrefix, value: value, lines: &lines) {
                    encoded = true
                    break
                }
            }

            if !encoded {
                print(encoders)
                throw ConfigSerializationError.cannotSerialize(value: "\(value)")
            }
        }
    }
}
