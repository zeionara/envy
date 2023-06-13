import Foundation

// typealias RecursiveCall = (
//     content: [String: Any], _ prefix: String,
//     _ keySeparator: String, _ keyPartSeparator: String, _ keyPartSeparatorReplacement: String,
//     _ uppercase: Bool, _ lowercase: Bool
// ) throws -> [String]

struct ObjectArrayConfigEncoder: EnvOnlyConfigReaderProperty, BasicConfigPropertyEncoder {
    typealias ValueType = [[String: Any]]

    let keySeparator: String
    let keyPartSeparator: String
    let keyPartSeparatorReplacement: String

    let uppercase: Bool
    let lowercase: Bool
    
    let objectEncoder: ObjectConfigEncoder

    // let recursiveCall: RecursiveCall

    func encodeConfigProperty(env: String, value: Any, lines: inout [String]) throws {
        let items = try encodeConfigProperty(value)
        let nMaxPaddingZeros = Int(ceil(log(Double(items.count))/log(10)))

        for (i, item) in items.enumerated() {
            try objectEncoder.encodeConfigProperty(env: "\(env)\(keySeparator)\(String(format: "%0\(nMaxPaddingZeros)d", i))", value: item, lines: &lines)
            // lines.append(
            //     contentsOf: try serializeConfig(
            //         content: item, prefix: "\(env)\(keySeparator)\(String(format: "%0\(nMaxPaddingZeros)d", i))",
            //         keySeparator: keySeparator, keyPartSeparator: keyPartSeparator, keyPartSeparatorReplacement: keyPartSeparatorReplacement,
            //         uppercase: uppercase, lowercase: lowercase
            //     )
            // )
        }
    }
}
