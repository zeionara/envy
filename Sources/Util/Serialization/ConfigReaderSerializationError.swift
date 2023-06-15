enum ConfigReaderSerializationError: Error {
    case readerIsNotSupported
    case cannotSerialize(value: String)
    case cannotOpenFile(path: String)

    public var description: String {
        switch self {
            case .readerIsNotSupported:
                return "Reader is not supported"
            case let .cannotSerialize(value):
                return "Cannot serialize value \(value)"
            case let .cannotOpenFile(path):
                return "Cannot open file at url \(path)"
        }
    }
}
