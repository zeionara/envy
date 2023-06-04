public extension String {
    func appendingFileExtension(_ fileExtension: String) -> String {
        return "\(self).\(fileExtension)"
    }
}
