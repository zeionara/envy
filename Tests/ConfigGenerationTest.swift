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

private let configWithListOfObjectsSource = """
foo:
    - bar: baz
    - corge: grault
"""

private let configWithListOfObjectsDestination = """
FOO_0_BAR=baz
FOO_1_CORGE=grault
"""

private let configWithDashedNameSource = """
foo:
    bar-baz: qux
"""

private let configWithDashedNameDestination = """
FOO__BAR_BAZ=qux
"""

private let configWithDashedNameFirstLevelSource = """
foo-bar:
    baz: qux
"""

private let configWithDashedNameFirstLevelDestination = """
FOO_BAR__BAZ=qux
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

    func testListOfObjectsHandling () throws {
        XCTAssertEqual(try Config(parsing: configWithListOfObjectsSource).toString(), configWithListOfObjectsDestination)
    }

    func testDashedName () throws {
        XCTAssertEqual(try Config(parsing: configWithDashedNameSource).toString(), configWithDashedNameDestination)
    }

    func testDashedNameFirstLevel () throws {
        XCTAssertEqual(try Config(parsing: configWithDashedNameFirstLevelSource).toString(), configWithDashedNameFirstLevelDestination)
    }
}
