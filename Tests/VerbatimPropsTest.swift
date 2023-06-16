import XCTest

@testable
import envy

struct ConfigSpec {
    let config: String

    let env: String
    let reader: String

    func test () throws {
        let config = try Config(parsing: config)

        try XCTAssertEqual(config.toString(), env)
        try XCTAssertEqual(config.toStringReader(as: .js), reader)
    }
}

private let dummy = ConfigSpec(
    config: """
    foo:
        verbatim: true
        value: bar
    """,
    env: """
    """,
    reader: """
    export const config = {
      foo: bar
    }
    """
)

final class VerbatimPropsTest: XCTestCase {
    func testConfig () throws {
        try dummy.test()
        // let config = try Config(parsing: configDummy)

        // try XCTAssertEqual(config.toString(), envDummy)
        // try XCTAssertEqual(config.toStringReader(as: .js), readerDummy)
    }
}
