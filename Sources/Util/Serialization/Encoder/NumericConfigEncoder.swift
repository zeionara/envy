struct NumericConfigEncoder: SingleLineConfigProperty, EnvOnlyConfigReaderProperty, BasicConfigPropertyEncoder {
    typealias ValueType = any Numeric

    // func encodeConfigProperty(_ value: Any) throws -> ValueType { // either value either environment variable name (env) may be returned as a result of encoding
    //     guard let value = value as? ValueType else {
    //         throw ConfigEncodingError.unsupportedValueScheme
    //     }

    //     return value
    // }
}
