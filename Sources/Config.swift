import Foundation
import OrderedCollections

import Yams

private let NEW_LINE = "\n"
private let EMPTY_STRING = ""
private let UNDERSCORE = "_"
private let COMMA = ","

enum YamlParsingError: Error {
    case incorrectResultFormat
    case cannotSerialize(value: String)

    public var description: String {
        switch self {
            case .incorrectResultFormat:
                return "Incorrect result format, cannot convert to a generic collection"
            case let .cannotSerialize(value):
                return "Cannot serialize value \(value)"
        }
    }
}

enum ReaderGenerationError: Error {
    case readerIsNotSupported
    case cannotSerialize(value: String)
}

private func serialize (content: [String: Any], prefix: String = EMPTY_STRING, separator: String = UNDERSCORE, uppercase: Bool = true, lowercase: Bool = false) throws -> [String] {
    var lines: [String] = []

    let prefixWithSeparator = prefix == EMPTY_STRING ? prefix : prefix + separator
    var isFirstKey = prefix == EMPTY_STRING

    for (key, value) in content.sorted(by: { $0.key < $1.key }) {
        let uppercasedKey = uppercase ? key.uppercased() : lowercase ? key.lowercased() : key

        if (isFirstKey) {
            isFirstKey = false
        } else if (prefix == EMPTY_STRING) {
            lines.append(EMPTY_STRING)
        }

        if let valueAsString = value as? String {
            lines.append("\(prefixWithSeparator)\(uppercasedKey)=\(valueAsString)")
        } else if let valueAsArray = value as? [String] {
            lines.append("\(prefixWithSeparator)\(uppercasedKey)=\(valueAsArray.joined(separator: COMMA))")
        } else if let valueAsMap = value as? [String: Any] {
            lines.append(contentsOf: try serialize(content: valueAsMap, prefix: "\(prefixWithSeparator)\(uppercasedKey)", separator: separator, uppercase: uppercase, lowercase: lowercase))
        } else {
            throw YamlParsingError.cannotSerialize(value: "\(value)")
        }

    }

    return lines
}

struct AnyEncodable: Encodable {
    let encodeValue: (Encoder) throws -> Void

    init<T: Encodable> (storing value: T) {
        encodeValue = value.encode
    }

    func encode (to encoder: Encoder) throws {
        try encodeValue(encoder)
    }
}

func wrapAny (_ content: [String: Any], prefix: String = EMPTY_STRING, separator: String = UNDERSCORE, uppercase: Bool = true, lowercase: Bool = false) throws -> AnyEncodable {
    // var wrappedContent: [String: AnyEncodable] = [:]
    var wrappedContent: OrderedDictionary<String, AnyEncodable> = [:]

    let prefixWithSeparator = prefix == EMPTY_STRING ? prefix : prefix + separator

    for (key, value) in content.sorted(by: { $0.key < $1.key }) {
        let uppercasedKey = uppercase ? key.uppercased() : lowercase ? key.lowercased() : key
        let nextPrefix = "\(prefixWithSeparator)\(uppercasedKey)"

        if let _ = value as? String {
            wrappedContent[key] = AnyEncodable(storing: "process.env.\(nextPrefix)")
        } else if let _ = value as? [String] {
            wrappedContent[key] = AnyEncodable(storing: "process.env.\(nextPrefix)")
            // wrappedContent[key] = AnyEncodable(storing: valueAsArray)
        } else if let valueAsMap = value as? [String: Any] {
            wrappedContent[key] = try wrapAny(valueAsMap, prefix: nextPrefix, separator: separator, uppercase: uppercase, lowercase: lowercase)
        } else {
            throw ReaderGenerationError.cannotSerialize(value: "\(value)")
        }
    }

    return AnyEncodable(storing: wrappedContent)
}

struct Config {
    private let content: [String: Any]

    init (from sourcePath: String) throws {
        try self.init(parsing: File.read(from: Path.Assets.appendingPathComponent(sourcePath)))
    }

    init (parsing content: String) throws {
        guard let content = try Yams.load(yaml: content) as? [String: Any] else {
            throw YamlParsingError.incorrectResultFormat
        }

        self.content = content
    }

    func toString (separator: String = UNDERSCORE, uppercase: Bool = true, lowercase: Bool = false) throws -> String {
        return try serialize(content: self.content, separator: separator, uppercase: uppercase, lowercase: lowercase).joined(separator: NEW_LINE)
    }

    func export (to destinationPath: String, as format: ConfigFormat = .snakeCase) throws {
        let content = try toString(separator: format.separator, uppercase: format.uppercase, lowercase: format.lowercase)
        try "\(content)\(NEW_LINE)".write(to: Path.Assets.appendingPathComponent(destinationPath), atomically: true, encoding: .utf8)
    }

    func exportReader (to destinationPath: String, as format: ConfigReaderFormat) throws {
        switch format {
            case .js:
                // let reader = ConfigReader(content)
                // let data = try JSONEncoder().encode(reader)
                let data = try JSONEncoder().encode(wrapAny(content))
                let string = String(data: data, encoding: .utf8)

                if let string = string {
                    print(string)
                }
                // print(destinationPath.appendingFileExtension(format.fileExtension))
            // default:
            //     throw ReaderGenerationError.readerIsNotSupported
        }
    }
}
