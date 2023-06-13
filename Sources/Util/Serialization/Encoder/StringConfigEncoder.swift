struct StringConfigEncoder: SingleLineConfigProperty, EnvOnlyConfigReaderProperty, BasicConfigPropertyEncoder {
    typealias ValueType = String
}
