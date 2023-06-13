enum ConfigEncodingError: Error {
    case unsupportedValueScheme
}

protocol ConfigEncoder {
    associatedtype ValueType

    func encodeConfigProperty(_ value: Any) throws -> ValueType
    func encodeConfigReaderProperty(env: String, value: Any) throws -> Any

    func encodeConfigProperty(env: String, value: Any, lines: inout [String]) throws
    func encodeConfigReaderProperty(key: String, env: String, value: Any, content: inout [String: Any]) throws
}

extension ConfigEncoder {
    func push<T>(key: String, value: T, lines: inout [String]) {
        lines.append("\(key)=\(value)")
    }

    func push<T>(key: String, value: T, content: inout [String: Any]) {
        content[key] = value
    }
}
