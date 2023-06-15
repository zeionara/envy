import Foundation

func hasMultipartKeys (within content: [String: Any], separator: String = DASH) -> Bool {
    for (key, value) in content {
        if (key.contains(separator)) {
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
