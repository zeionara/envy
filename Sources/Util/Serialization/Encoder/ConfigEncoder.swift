enum ConfigEncodingError: Error {
    case unsupportedValueScheme
    case noValue(byKey: Any)
}

protocol ConfigEncoder {
    associatedtype ValueType

    func encodeConfigProperty(_ value: Any) throws -> ValueType

    func encodeConfigProperty(env: String, value: Any, lines: inout [String]) throws
    func encodeConfigReaderProperty(key: String?, env: String, value: Any, content: inout [String: Any]) throws
}

protocol SingleLineConfigProperty: ConfigEncoder {}
protocol EnvOnlyConfigReaderProperty: ConfigEncoder {}
protocol BasicConfigPropertyEncoder: ConfigEncoder {}

extension ConfigEncoder {
    func push<T>(key: String, value: T, lines: inout [String]) {
        lines.append("\(key)=\(value)")
    }

    func push<T>(key: String, value: T, content: inout [String: Any]) {
        content[key] = value
    }

    func pushEnv(key: String, value: String, content: inout [String: Any]) {
        content[key] = "process.env.\(value)"
    }
}

extension SingleLineConfigProperty {
    func encodeConfigProperty(env: String, value: Any, lines: inout [String]) throws { // multiple lines can be added to config as a result of encoding
        self.push(key: env, value: try encodeConfigProperty(value), lines: &lines)
    }
}

extension EnvOnlyConfigReaderProperty {
    func encodeConfigReaderProperty(key: String?, env: String, value: Any, content: inout [String: Any]) throws { // multiple props can be added to config as a result of encoding
        let _ = try encodeConfigProperty(value)// make sure that passed value is indeed of a required type

        if let key = key {
            pushEnv(key: key, value: env, content: &content)
        }
    }
}

extension BasicConfigPropertyEncoder {
    func encodeConfigProperty(_ value: Any) throws -> ValueType { // either value either environment variable name (env) may be returned as a result of encoding
        guard let value = value as? ValueType else {
            throw ConfigEncodingError.unsupportedValueScheme
        }

        return value
    }
}
