import Foundation
import Yams

struct Config {
    private let content: [String: Any]

    init (from sourcePath: String) throws {
        try self.init(parsing: File.read(from: Path.Assets.appendingPathComponent(sourcePath)))
    }

    init (parsing content: String) throws {
        guard let content = try Yams.load(yaml: content) as? [String: Any] else {
            throw ConfigSerializationError.incorrectResultFormat
        }

        self.content = content
    }

    func toString (separator: String = UNDERSCORE, uppercase: Bool = true, lowercase: Bool = false) throws -> String {
        return try serializeConfig(content: self.content, separator: separator, uppercase: uppercase, lowercase: lowercase).joined(separator: NEW_LINE)
    }

    func export (to destinationPath: String, as format: ConfigFormat = .snakeCase) throws {
        let content = try toString(separator: format.separator, uppercase: format.uppercase, lowercase: format.lowercase)
        try "\(content)\(NEW_LINE)".write(to: Path.Assets.appendingPathComponent(destinationPath), atomically: true, encoding: .utf8)
    }

    func exportReader (to destinationPath: String, as format: ConfigReaderFormat) throws {
        switch format {
            case .js:
                let url = Path.Assets.appendingPathComponent(destinationPath.appendingFileExtension(format.fileExtension))

                guard let outputJson = OutputStream(url: url, append: false) else {
                    throw ConfigReaderSerializationError.cannotOpenFile(path: destinationPath)
                }

                outputJson.open()

                let _ = try JSONSerialization.writeJSONObject(wrapConfigReaderJS(content), toStream: outputJson, options: [.sortedKeys, .prettyPrinted])
                outputJson.close()

                let content = try File.read(from: url)
                let fixedContent = (
                    "export const config = \(content.replacingOccurrences(of: " : \"", with: ": ").replacingOccurrences(of: "\"\n", with: "\n").replacingOccurrences(of: "\",\n", with: ",\n"))"
                )

                try fixedContent.write(to: url, atomically: true, encoding: .utf8)
        }
    }
}
