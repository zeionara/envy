import XCTest

@testable
import envy

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
              foo: "bar"
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
                  baz: "qux"
                },
                verbatim: true
              }
            }
            """
        ).test()
    }
}
