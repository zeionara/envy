let NEW_LINE = "\n"
let EMPTY_STRING = ""
let UNDERSCORE = "_"
let COMMA = ","

public extension String {
    func appendingFileExtension(_ fileExtension: String) -> String {
        return "\(self).\(fileExtension)"
    }
}
