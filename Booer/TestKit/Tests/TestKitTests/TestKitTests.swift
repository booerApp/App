import XCTest
@testable import TestKit

final class TestKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TestKit().text, "Hello, World!")
    }
}
