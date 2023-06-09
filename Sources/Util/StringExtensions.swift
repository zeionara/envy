let NEW_LINE = "\n"
let EMPTY_STRING = ""
let UNDERSCORE = "_"
let DOUBLE_UNDERSCORE = "__"
let COMMA = ","
let DASH = "-"

public enum NamingConventionConversionError: Error {
    case cannotInferSourceNamingConvention(of: String)
}

public enum NamingConvention {
    case kebabCase
    case unknown

    var regex: Regex<Substring>? {
        switch self {
            case .kebabCase:
                return try? Regex("[a-z0-9]+(?:-[a-z0-9]+)*")
            case .unknown:
                return nil
        }
    }
}

public extension String {
    func appendingFileExtension(_ fileExtension: String) -> String {
        return "\(self).\(fileExtension)"
    }
}

public extension String {

    var namingConvention: NamingConvention {
        if let _ = try? NamingConvention.kebabCase.regex?.wholeMatch(in: self) {
            return .kebabCase
        }
        
        return .unknown
    }

    var camelCased: String {
        get throws {
            switch self.namingConvention {
                case .kebabCase:
                    let components = self.components(separatedBy: "-")

                    if components.count > 0 {
                        return "\(components[0])\(components[1...].map{ $0.capitalized }.joined())"
                    }
                    return ""
                case .unknown:
                    throw NamingConventionConversionError.cannotInferSourceNamingConvention(of: self)
            }
            // let pattern = try Regex("[a-z0-9]+(?:-[a-z0-9]+)*")

            // if let match = try pattern.wholeMatch(in: self) {
            //     print(match.0)
            // }

            // return "--"
        }
    }
}
