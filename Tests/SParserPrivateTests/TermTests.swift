import XCTest
import SParserLibs
@testable import SParserPrivate

class TermTests: XCTestCase {
  func testNamedBuildConditionString() {
    let term = Term.named("number")

    let expected = "let number = try readNumber()"
    var usedTermNames = Set<String>()
    XCTAssertEqual(term.buildConditionString(usedTermNames: &usedTermNames), expected)
  }
  func testQuotedBuildConditionString() {
    let term = Term.quoted("+")

    let expected = "matches(string: \"+\")"
    var usedTermNames = Set<String>()
    XCTAssertEqual(term.buildConditionString(usedTermNames: &usedTermNames), expected)
  }
}
