let NEW_LINE = "\n"
let EMPTY_STRING = ""
let UNDERSCORE = "_"
let DOUBLE_UNDERSCORE = "__"
let COMMA = ","
let DASH = "-"

public extension String {
    func appendingFileExtension(_ fileExtension: String) -> String {
        return "\(self).\(fileExtension)"
    }
}
