import Foundation

let defaultFileManager = FileManager.default

struct Path {
    static let Assets = URL(fileURLWithPath: defaultFileManager.currentDirectoryPath).appendingPathComponent("Assets")
}
