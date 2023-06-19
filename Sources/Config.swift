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

    func toString (separator: String = UNDERSCORE, uppercase: Bool = true, lowercase: Bool = false, keyPartSeparator: String = DASH, root: String? = nil) throws -> String {
        var lines: [String] = []

        let keySeparator = hasMultipartKeys(within: content) || root != nil && isMultipartKey(root!) ? "\(separator)\(separator)" : separator
        let keySeparatorReplacement = separator

        var patchedRoot = root ?? EMPTY_STRING

        if (patchedRoot != EMPTY_STRING) {
            let casedRoot = uppercase ? patchedRoot.uppercased() : lowercase ? patchedRoot.lowercased() : patchedRoot

            if (keyPartSeparator != keySeparator) {
                patchedRoot = casedRoot.replacingOccurrences(of: keyPartSeparator, with: keySeparatorReplacement)
            }
        }

        try ObjectConfigEncoder(
            keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: keySeparatorReplacement,
            uppercase: uppercase, lowercase: lowercase
        ).encodeConfigProperty(env: patchedRoot, value: content, lines: &lines)

        return (lines.joined(separator: NEW_LINE) as String).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func export (to destinationPath: String, as format: ConfigFormat = .snakeCase, prefix: String? = nil) throws {
        let content = try toString(separator: format.separator, uppercase: format.uppercase, lowercase: format.lowercase, root: prefix)
        try "\(content)\(NEW_LINE)".write(to: Path.Assets.appendingPathComponent(destinationPath), atomically: true, encoding: .utf8)
    }

    func toStringReader (
        as format: ConfigReaderFormat, separator: String = UNDERSCORE, keyPartSeparator: String = DASH, uppercase: Bool = true, lowercase: Bool = false, root: String? = nil
    ) throws -> String {
        switch format {
            case .js:
                // let keySeparator = hasMultipartKeys(within: content) ? "\(separator)\(separator)" : separator
                // let patchedRoot = root == nil ? EMPTY_STRING : "\(root!)\(keySeparator)"
                let keySeparator = hasMultipartKeys(within: content) || root != nil && isMultipartKey(root!) ? "\(separator)\(separator)" : separator
                let keySeparatorReplacement = separator

                var patchedRoot = root ?? EMPTY_STRING

                var encodedContent: [String: Any] = [:]

                if (patchedRoot != EMPTY_STRING) {
                    let casedRoot = uppercase ? patchedRoot.uppercased() : lowercase ? patchedRoot.lowercased() : patchedRoot

                    if (keyPartSeparator != keySeparator) {
                        patchedRoot = casedRoot.replacingOccurrences(of: keyPartSeparator, with: keySeparatorReplacement)
                    }
                }

                try ObjectConfigEncoder(
                    keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: keySeparatorReplacement,
                    // keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: separator,
                    uppercase: uppercase, lowercase: lowercase
                ).encodeConfigReaderProperty(key: EMPTY_STRING, env: patchedRoot, value: content, content: &encodedContent)

                // print(encodedContent)

                guard let rootValue = encodedContent[EMPTY_STRING] else {
                    throw ConfigEncodingError.noValue(byKey: EMPTY_STRING)
                }

                let data = try JSONSerialization.data(
                    withJSONObject: rootValue,
                    options: [.sortedKeys, .prettyPrinted]
                )
                let content = String(decoding: data, as: UTF8.self)

                return try (
                    // "export const config = \(content.replacingOccurrences(of: " : \"", with: ": ").replacingOccurrences(of: "\"\n", with: "\n").replacingOccurrences(of: "\",\n", with: ",\n"))"
                    "export const config = \(content)"
                ).dropQuotationMarksAroundValues().dropQuotationMarksAroundKeys()
        }
    }

    func exportReader (to destinationPath: String, as format: ConfigReaderFormat, prefix: String? = nil) throws {
        try toStringReader(as: format, root: prefix).write(
            to: Path.Assets.appendingPathComponent(destinationPath.appendingFileExtension(format.fileExtension)),
            atomically: true,
            encoding: .utf8
        )
    }
}
