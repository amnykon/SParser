import XCTest
import SParserLibs
@testable import SParserPrivate

class TermTests: XCTestCase {
  func testNamedBuildConditionString() {
    let term = Term.named("number")

    let expected = "let number = try readNumber()"
    XCTAssertEqual(term.buildConditionString(), expected)
  }
  func testQuotedBuildConditionString() {
    let term = Term.quoted("+")

    let expected = "matches(string: \"+\")"
    XCTAssertEqual(term.buildConditionString(), expected)
  }
}
