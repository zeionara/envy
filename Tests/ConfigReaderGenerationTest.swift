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
  "baz" : {
    "qux": process.env.BAZ_QUX
  },
  "corge" : [
    {
      "grault": process.env.CORGE_0_GRAULT
    }
  ],
  "foo" : {
    "bar": process.env.FOO_BAR
  }
}
"""


final class ReaderConfigGenerationTest: XCTestCase {
    func testTinyConfig () throws {
        // try print(Config(parsing: configTiny).serializeReader(as: .js))
        try XCTAssertEqual(Config(parsing: tinyConfig).serializeReader(as: .js), tinyConfigReader)
    }
}
