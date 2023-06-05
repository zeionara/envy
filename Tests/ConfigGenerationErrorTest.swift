import XCTest

@testable
import envy

private let configWithListOfObjectsSource = """
foo:
    - bar: baz
    - corge: grault
"""

private let configWithListOfObjectsDestination = """
FOO_0_BAR=baz
FOO_1_CORGE=grault
"""

enum FailureTypeError: Error {
    case incorrectErrorType
}

final class ConfigGenerationErrorTest: XCTestCase {
    func testListOfObjectsHandling () throws {
        XCTAssertEqual(try Config(parsing: configWithListOfObjectsSource).toString(), configWithListOfObjectsDestination)
        // try XCTAssertThrowsError(try Config(parsing: configWithListOfObjects).toString()) { error in
        //     switch error {
        //         case let ConfigSerializationError.cannotSerialize(value):
        //             XCTAssertEqual(value, "[[AnyHashable(\"bar\"): \"baz\"], [AnyHashable(\"corge\"): \"grault\"]]")
        //         default:
        //             throw FailureTypeError.incorrectErrorType
        //     }
        //     // guard let error = error as? ConfigSerializationError else {
        //     //     throw FailureTypeError.incorrectErrorType
        //     // }
        // }
    }
}
