import Foundation

func hasMultipartKeys (within content: [String: Any], separator: String = DASH) -> Bool {
    for (key, value) in content {
        if (isMultipartKey(key, separator: separator)) {
            return true
        }
        if let value = value as? [String: Any] {
            if (hasMultipartKeys(within: value, separator: separator)) {
                return true
            }
        }
    }

    return false
}

func isMultipartKey (_ key: String, separator: String = DASH) -> Bool {
    return key.contains(separator)
}
