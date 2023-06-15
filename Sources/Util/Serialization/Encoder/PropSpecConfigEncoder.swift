struct PropSpec {
    let value: Any
    let verbatim: Bool
}

struct PropSpecConfigEncoder: ConfigEncoder {
    typealias ValueType = PropSpec

    let encoders: [any ConfigEncoder] = [StringConfigEncoder(), NumericConfigEncoder()]

    func encodeConfigProperty(_ value: Any) throws -> ValueType {
        guard let value = value as? [String: Any], let wrappedValue = value["value"], let verbatim = value["verbatim"] as? Bool else {
            throw ConfigEncodingError.unsupportedValueScheme
        }

        return PropSpec(value: wrappedValue, verbatim: verbatim)
    }

    func encodeConfigProperty (env: String, value: Any, lines: inout [String]) throws {
        let spec = try encodeConfigProperty(value)

        if !spec.verbatim {
            var encoded = false

            for encoder in encoders {
                try encoder.encodeConfigProperty(env: env, value: spec.value, lines: &lines)

                encoded = true
                break
            }

            if !encoded {
                throw ConfigSerializationError.cannotSerialize(value: "\(spec.value)")
            }
        }
    }

    func encodeConfigReaderProperty (key: String, env: String, value: Any, content: inout [String: Any], root: Bool = true) throws {
        let spec = try encodeConfigProperty(value)

        if spec.verbatim {
            content[key] = spec.value
        } else {
            var encoded = false

            for encoder in encoders {
                try encoder.encodeConfigReaderProperty(key: key, env: env, value: spec.value, content: &content, root: root)

                encoded = true
                break
            }

            if !encoded {
                throw ConfigSerializationError.cannotSerialize(value: "\(spec.value)")
            }
        }
    }
}
