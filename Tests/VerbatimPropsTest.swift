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


final class VerbatimPropsTest: XCTestCase {
    func testDummyConfig () throws {
        try ConfigSpec(
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
        ).test()
    }

    func testTransparency () throws {
        try ConfigSpec(
            config: """
            foo:
                verbatim: false
                value:
                  - bar
                  - baz
            """,
            env: """
            FOO=bar,baz
            """,
            reader: """
            export const config = {
              foo: process.env.FOO
            }
            """
        ).test()
    }

    func testNesting () throws {
        try ConfigSpec(
            config: """
            foo:
                verbatim: true
                value:
                    verbatim: true
                    bar:
                        baz: qux
            """,
            env: """
            """,
            reader: """
            export const config = {
              foo: {
                bar: {
                  baz: qux
                },
                verbatim: true
              }
            }
            """
        ).test()
    }
}
