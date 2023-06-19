import XCTest

@testable
import envy

struct ConfigSpec {
    let config: String

    let env: String
    let reader: String

    func test (root: String? = nil) throws {
        let config = try Config(parsing: config)

        try XCTAssertEqual(config.toString(root: root), env)
        try XCTAssertEqual(config.toStringReader(as: .js, root: root), reader)
    }
}
