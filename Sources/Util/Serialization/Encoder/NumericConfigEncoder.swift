struct NumericConfigEncoder: SingleLineConfigProperty, EnvOnlyConfigReaderProperty, BasicConfigPropertyEncoder {
    typealias ValueType = any Numeric
}
