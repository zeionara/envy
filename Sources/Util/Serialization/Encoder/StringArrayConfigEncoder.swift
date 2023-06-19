struct StringArrayConfigEncoder: EnvOnlyConfigReaderProperty, BasicConfigPropertyEncoder {
    typealias ValueType = [String]

    func encodeConfigProperty(env: String, value: Any, lines: inout [String], root: Bool = true) throws {
        push(key: env, value: try encodeConfigProperty(value).joined(separator: COMMA), lines: &lines)
    }
}
