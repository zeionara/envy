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

    func toString (separator: String = UNDERSCORE, uppercase: Bool = true, lowercase: Bool = false, keyPartSeparator: String = DASH) throws -> String {
        var lines: [String] = []

        try ObjectConfigEncoder(
            keySeparator: hasMultipartKeys(within: content) ? "\(separator)\(separator)" : separator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: separator,
            uppercase: uppercase, lowercase: lowercase
        ).encodeConfigProperty(env: "", value: content, lines: &lines)

        return lines.joined(separator: NEW_LINE)
    }

    func export (to destinationPath: String, as format: ConfigFormat = .snakeCase) throws {
        let content = try toString(separator: format.separator, uppercase: format.uppercase, lowercase: format.lowercase)
        try "\(content)\(NEW_LINE)".write(to: Path.Assets.appendingPathComponent(destinationPath), atomically: true, encoding: .utf8)
    }

    func toStringReader (as format: ConfigReaderFormat, separator: String = UNDERSCORE, keyPartSeparator: String = DASH, uppercase: Bool = true, lowercase: Bool = false) throws -> String {
        switch format {
            case .js:
                var encodedContent: [String: Any] = [:]

                try ObjectConfigEncoder(
                    keySeparator: hasMultipartKeys(within: content) ? "\(separator)\(separator)" : separator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: separator,
                    uppercase: uppercase, lowercase: lowercase
                ).encodeConfigReaderProperty(key: EMPTY_STRING, env: EMPTY_STRING, value: content, content: &encodedContent)

                print(encodedContent)

                let data = try JSONSerialization.data(
                    withJSONObject: encodedContent,
                    // withJSONObject: wrapConfigReaderJS(
                    //     content,
                    //     keySeparator: hasMultipartKeys(within: content) ? "\(separator)\(separator)" : separator, keyPartSeparatorReplacement: separator
                    // ),
                    options: [.sortedKeys, .prettyPrinted]
                )
                let content = String(decoding: data, as: UTF8.self)

                return try (
                    "export const config = \(content.replacingOccurrences(of: " : \"", with: ": ").replacingOccurrences(of: "\"\n", with: "\n").replacingOccurrences(of: "\",\n", with: ",\n"))"
                ).dropQuotationMarksAroundKeys()
        }
    }

    func exportReader (to destinationPath: String, as format: ConfigReaderFormat) throws {
        try toStringReader(as: format).write(
            to: Path.Assets.appendingPathComponent(destinationPath.appendingFileExtension(format.fileExtension)),
            atomically: true,
            encoding: .utf8
        )
    }
}
