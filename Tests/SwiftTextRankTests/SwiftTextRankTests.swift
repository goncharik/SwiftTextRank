import XCTest
@testable import SwiftTextRank

final class SwiftTextRankTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftTextRank().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
