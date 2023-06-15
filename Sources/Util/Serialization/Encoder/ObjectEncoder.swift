protocol ObjectEncoder {
    var keySeparator: String { get }
    var keyPartSeparator: String { get }
    var keyPartSeparatorReplacement: String { get }

    var uppercase: Bool { get }
    var lowercase: Bool { get }
}
