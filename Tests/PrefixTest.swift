import XCTest

@testable
import envy

final class PrefixTest: XCTestCase {
    func testSinglePartPrefix () throws {
        try ConfigSpec(
            config: """
            foo:
                bar: baz
            """,
            env: """
            ROOT_FOO_BAR=baz
            """,
            reader: """
            export const config = {
              foo: {
                bar: process.env.ROOT_FOO_BAR
              }
            }
            """
        ).test(root: "root")
    }

    func testMultiPartPrefix () throws {
        try ConfigSpec(
            config: """
            foo:
                bar: baz
            """,
            env: """
            QUX_QUUX__FOO__BAR=baz
            """,
            reader: """
            export const config = {
              foo: {
                bar: process.env.QUX_QUUX__FOO__BAR
              }
            }
            """
        ).test(root: "qux-quux")
    }

    func testSinglePartPrefixAndMultiPartKey () throws {
        try ConfigSpec(
            config: """
            foo:
                bar-baz: baz
            """,
            env: """
            QUX__FOO__BAR_BAZ=baz
            """,
            reader: """
            export const config = {
              foo: {
                barBaz: process.env.QUX__FOO__BAR_BAZ
              }
            }
            """
        ).test(root: "qux")
    }

    func testMultiPartPrefixAndMultiPartKey () throws {
        try ConfigSpec(
            config: """
            foo:
                bar-baz: baz
            """,
            env: """
            QUX_QUUX__FOO__BAR_BAZ=baz
            """,
            reader: """
            export const config = {
              foo: {
                barBaz: process.env.QUX_QUUX__FOO__BAR_BAZ
              }
            }
            """
        ).test(root: "qux-quux")
    }
}
