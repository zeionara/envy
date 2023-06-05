enum ConfigSerializationError: Error {
    case incorrectResultFormat
    case cannotSerialize(value: String)

    public var description: String {
        switch self {
            case .incorrectResultFormat:
                return "Incorrect result format, cannot convert to a generic collection"
            case let .cannotSerialize(value):
                return "Cannot serialize value \(value)"
        }
    }
}
