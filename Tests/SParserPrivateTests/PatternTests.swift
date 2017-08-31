import XCTest
import SParserLibs
@testable import SParserPrivate

class PatternTests: XCTestCase {
  func testBuildEvaluatorString() {
    let pattern = Pattern(
      terms: [
        .named("lhs"),
        .quoted("+"),
        .named("rhs"),
      ],
      evaluator: "return rhs + lhs"
    )

    let expected = 
      "fileprivate func evalAddTerm(lhs: Parser.LhsType, rhs: Parser.RhsType) -> Parser.AddTermType {\n" +
      "  return rhs + lhs\n" +
      "}\n"
    XCTAssertEqual(pattern.buildEvaluatorString(ruleName:"addTerm"), expected)
  }

  func testBuildEvaluatorCall() {
    let pattern = Pattern(
      terms: [
        .named("lhs"),
        .quoted("+"),
        .named("rhs"),
      ],
      evaluator: "return rhs + lhs"
    )

    let expected = "return evalAddTerm(lhs: lhs, rhs: rhs)\n"
    XCTAssertEqual(pattern.buildEvaluatorCall(ruleName:"addTerm"), expected)
  }
}
