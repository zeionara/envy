enum ConfigReaderSerializationError: Error {
    case readerIsNotSupported
    case cannotSerialize(value: String)
    case cannotOpenFile(path: String)
}
