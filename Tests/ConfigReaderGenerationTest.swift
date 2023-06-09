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
        // let pattern = try Regex("\"(?<key>[a-z0-9]+(?:[A-Z0-9][a-z0-9]*)*)\"\\s*:\\s*")
        let pattern = try Regex("\"(?<key>[a-z0-9]+)\"\\s*:\\s*")
        let example = "\"foo\":   \"bar\", \"bar\": \"baz\""
        var mutableExample = example

        while true {
            print(mutableExample)
            if let result = try? pattern.firstMatch(in: mutableExample) {
                if let keyMatch = result["key"], let keyRange = keyMatch.range {
                    // let key = example[keyRange]
                    // print(type(of: keyRange), type(of: key))

                    // print(example[1..<6])

                    // let range: Range<String.Index> = example.startIndex..<example.startIndex
                    // let range: Range<String.Index> = keyRange
                    // var mutableExample = example

                    print("current key:", mutableExample[keyRange])
                    mutableExample.replaceSubrange(result.range, with: "\(mutableExample[keyRange]): ")

                }
                // print(example[result.range])
            } else {
                break
            }
        }

        print(mutableExample)

        // try print(Config(parsing: configTiny).serializeReader(as: .js))
        // try XCTAssertEqual(Config(parsing: tinyConfig).serializeReader(as: .js), tinyConfigReader)
    }
}
