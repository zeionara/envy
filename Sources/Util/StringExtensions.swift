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
    case camelCase
    case unknown

    var pattern: String? {
        switch self {
            case .kebabCase:
                return "[a-z0-9]+(?:-[a-z0-9]+)*"
            case .camelCase:
                return "[a-z0-9]+(?:[A-Z0-9][a-z0-9]*)*"
            case .unknown:
                return nil
        }
    }

    var regex: Regex<Substring>? {
        if let pattern = pattern {
            return try? Regex(pattern)
        }
        return nil
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
        if let _ = try? NamingConvention.camelCase.regex?.wholeMatch(in: self) {
            return .camelCase
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
                case .camelCase:
                    return self
                case .unknown:
                    print(self)
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

public extension String {
    func dropQuotationMarksAroundKeys () throws -> String {
        let pattern = try Regex("\"(?<key>\(NamingConvention.camelCase.pattern!))\"\\s*:\\s*")
        var mutableSelf = self

        while true {
            if let result = try? pattern.firstMatch(in: mutableSelf) {
                if let keyMatch = result["key"], let keyRange = keyMatch.range {
                    mutableSelf.replaceSubrange(result.range, with: "\(mutableSelf[keyRange]): ")
                }
            } else {
                break
            }
        }

        return mutableSelf
    }
}
