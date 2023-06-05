import XCTest

@testable
import envy

private let configWithListOfObjects = """
foo:
    - bar: baz
    - corge: grault
"""

enum FailureTypeError: Error {
    case incorrectErrorType
}

final class ConfigGenerationErrorTest: XCTestCase {
    func testListOfObjectsHandling () throws {
        try XCTAssertThrowsError(try Config(parsing: configWithListOfObjects).toString()) { error in
            switch error {
                case let ConfigSerializationError.cannotSerialize(value):
                    XCTAssertEqual(value, "[[AnyHashable(\"bar\"): \"baz\"], [AnyHashable(\"corge\"): \"grault\"]]")
                default:
                    throw FailureTypeError.incorrectErrorType
            }
            // guard let error = error as? ConfigSerializationError else {
            //     throw FailureTypeError.incorrectErrorType
            // }
        }
    }
}
