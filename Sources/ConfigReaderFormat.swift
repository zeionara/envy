enum ConfigReaderFormat {
    case js

    var fileExtension: String {
        switch self {
            case .js:
                return "js"
        }
    }
}
