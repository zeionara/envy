import XCTest

@testable
import envy

private let kebabCaseSource = """
foo:
    bar: baz
    qux: quux
"""

private let kebabCaseDestination = """
foo-bar=baz
foo-qux=quux
"""

private let twoLevelConfigSource = """
foo:
    bar: baz
    qux: quux
"""

private let twoLevelConfigDestination = """
FOO_BAR=baz
FOO_QUX=quux
"""

private let threeLevelConfigWithListSource = """
foo:
    bar:
        baz: qux
corge:
    grault:
        garply:
            - waldo
            - fred
"""

private let threeLevelConfigWithListDestination = """
CORGE_GRAULT_GARPLY=waldo,fred

FOO_BAR_BAZ=qux
"""

private let configWithNumbersSource = """
foo: 1
bar:
    - 17
    - 19
baz:
    qux: 2023
"""

private let configWithNumbersDestination = """
BAR=17,19

BAZ_QUX=2023

FOO=1
"""

final class ConfigGenerationTest: XCTestCase {
    func testTwoLevelConfigHandling() throws {
        XCTAssertEqual(try Config(parsing: twoLevelConfigSource).toString(), twoLevelConfigDestination)
    }

    func testThreeLevelConfigWithListHandling() throws {
        // print(try Config(parsing: threeLevelConfigWithListSource).toString())
        XCTAssertEqual(try Config(parsing: threeLevelConfigWithListSource).toString(), threeLevelConfigWithListDestination)
    }

    func testKebabCaseHandling() throws {
        // print(try Config(parsing: threeLevelConfigWithListSource).toString())
        XCTAssertEqual(try Config(parsing: kebabCaseSource).toString(separator: "-", uppercase: false, lowercase: true), kebabCaseDestination)
    }

    func testNumbersHandling() throws {
        XCTAssertEqual(try Config(parsing: configWithNumbersSource).toString(), configWithNumbersDestination)
    }
}
