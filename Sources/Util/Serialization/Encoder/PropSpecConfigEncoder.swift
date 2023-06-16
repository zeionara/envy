struct PropSpec {
    let value: Any
    let verbatim: Bool
}

class PropSpecConfigEncoder: ConfigEncoder {
    typealias ValueType = PropSpec

    var encoders: [any ConfigEncoder] = []

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
                if let _ = try? encoder.encodeConfigProperty(env: env, value: spec.value, lines: &lines) {
                    encoded = true
                    break
                }
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
                // print(encoder, spec.value)
                if let _ = try? encoder.encodeConfigReaderProperty(key: key, env: env, value: spec.value, content: &content, root: root) {
                    encoded = true
                    break
                }
                // do {
                //     try encoder.encodeConfigReaderProperty(key: key, env: env, value: spec.value, content: &content, root: root)
                // } catch {
                //     print(error)
                // }
            }

            if !encoded {
                throw ConfigSerializationError.cannotSerialize(value: "\(spec.value)")
            }
        }
    }
}
