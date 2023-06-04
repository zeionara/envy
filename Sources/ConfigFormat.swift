enum ConfigFormat {
    case snakeCase
    case kebabCase

    var separator: String {
        switch self {
            case .snakeCase:
                return "_"
            case .kebabCase:
                return "-"
        }
    }

    var uppercase: Bool {
        switch self {
            case .snakeCase:
                return true
            case .kebabCase:
                return false
        }
    }

    var lowercase: Bool {
        switch self {
            case .snakeCase:
                return false
            case .kebabCase:
                return true
        }
    }
}
