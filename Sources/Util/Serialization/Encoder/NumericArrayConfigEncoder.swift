struct NumericArrayConfigEncoder: EnvOnlyConfigReaderProperty, BasicConfigPropertyEncoder {
    typealias ValueType = [any Numeric]

    func encodeConfigProperty(env: String, value: Any, lines: inout [String]) throws {
        push(key: env, value: try encodeConfigProperty(value).map{ "\($0)" }.joined(separator: COMMA), lines: &lines)
    }
}
