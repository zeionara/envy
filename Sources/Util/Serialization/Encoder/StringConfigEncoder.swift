struct StringConfigEncoder: ConfigEncoder {
    typealias ValueType = String

    func encodeConfigProperty(_ value: Any) throws -> ValueType { // either value either environment variable name (env) may be returned as a result of encoding
        guard let value = value as? String else {
            throw ConfigEncodingError.unsupportedValueScheme
        }

        return value
    }

    func encodeConfigReaderProperty(env: String, value: Any) throws -> Any { // either value either environment variable name (env) may be returned as a result of encoding
        return env
    }

    func encodeConfigProperty(env: String, value: Any, lines: inout [String]) throws { // multiple lines can be added to config as a result of encoding
        self.push(key: env, value: try encodeConfigProperty(value), lines: &lines)
    }

    func encodeConfigReaderProperty(key: String, env: String, value: Any, content: inout [String: Any]) throws { // multiple props can be added to config as a result of encoding
        self.push(key: key, value: try encodeConfigReaderProperty(env: env, value: value), content: &content)
    }
}
