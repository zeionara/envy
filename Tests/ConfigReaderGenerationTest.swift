import XCTest

@testable
import envy

private let tinyConfig = """
foo:
    bar:
        - 17
        - 19

baz:
    qux: quux

corge:
    - grault: garply
"""

private let tinyConfigReader = """
export const config = {
  baz: {
    qux: process.env.BAZ_QUX
  },
  corge: [
    {
      grault: process.env.CORGE_0_GRAULT
    }
  ],
  foo: {
    bar: process.env.FOO_BAR
  }
}
"""

private let tinyConfigWithMultipartKeys = """
foo:
    bar-baz:
        - 17
        - 19

baz-qux-quux:
    qux: quux

corge:
    - grault-garply: garply
"""

private let tinyConfigReaderWithMultipartKeys = """
export const config = {
  bazQuxQuux: {
    qux: process.env.BAZ_QUX_QUUX__QUX
  },
  corge: [
    {
      graultGarply: process.env.CORGE__0__GRAULT_GARPLY
    }
  ],
  foo: {
    barBaz: process.env.FOO__BAR_BAZ
  }
}
"""


final class ReaderConfigGenerationTest: XCTestCase {
    func testTinyConfig () throws {
        try XCTAssertEqual(Config(parsing: tinyConfig).toStringReader(as: .js), tinyConfigReader)
    }

    func testTinyConfigWithMultipartKeys () throws {
        try XCTAssertEqual(Config(parsing: tinyConfigWithMultipartKeys).toStringReader(as: .js), tinyConfigReaderWithMultipartKeys)
    }
}
