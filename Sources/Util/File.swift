import Foundation

struct File {
    static func read (from path: URL) throws -> String {
        return try String(contentsOf: path, encoding: .utf8)
    }
}
