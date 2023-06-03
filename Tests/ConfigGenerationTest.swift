import XCTest

final class ConfigGenerationTest: XCTestCase {
    func testTwoLevelConfigHandling() {
        let foo = "bar"

        XCTAssertEqual(foo, "bar")
    }
}
