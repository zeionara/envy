import Foundation

struct ObjectArrayConfigEncoder: EnvOnlyConfigReaderProperty, BasicConfigPropertyEncoder, ObjectEncoder {
    typealias ValueType = [[String: Any]]

    let keySeparator: String
    let keyPartSeparator: String
    let keyPartSeparatorReplacement: String

    let uppercase: Bool
    let lowercase: Bool
    
    let objectEncoder: ObjectConfigEncoder

    func encodeConfigReaderProperty (key: String?, env: String, value: Any, content: inout [String: Any], root: Bool = true) throws {
        // print(key, value, content)

        let items = try encodeConfigProperty(value)
        let nMaxPaddingZeros = Int(ceil(log(Double(items.count))/log(10)))

        if let key = key {
            content[try key.camelCased] = try items.enumerated().map { i, item in
                var subContent: [String: Any] = [:]

                // print(key, subContent)

                try objectEncoder.encodeConfigReaderProperty(key: nil, env: "\(env)\(keySeparator)\(String(format: "%0\(nMaxPaddingZeros)d", i))", value: item, content: &subContent, root: false)

                // print(key, subContent)

                return subContent
            }
        }
    }

    func encodeConfigProperty (env: String, value: Any, lines: inout [String], root: Bool = true) throws {
        let items = try encodeConfigProperty(value)
        let nMaxPaddingZeros = Int(ceil(log(Double(items.count))/log(10)))

        for (i, item) in items.enumerated() {
            try objectEncoder.encodeConfigProperty(env: "\(env)\(keySeparator)\(String(format: "%0\(nMaxPaddingZeros)d", i))", value: item, lines: &lines, root: false)
        }
    }
}
