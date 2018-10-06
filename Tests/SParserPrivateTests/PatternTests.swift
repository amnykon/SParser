import XCTest
import SParserLibs
@testable import SParserPrivate

class PatternTests: XCTestCase {
  func testBuildEvaluatorFunction() {
    let pattern = Pattern(
      terms: [
        .named("lhs"),
        .quoted("+"),
        .named("rhs"),
      ],
      evaluator: "return rhs + lhs",
      id: 0
    )

    let expected = """
        fileprivate func eval0AddTerm(lhs: Parser.LhsType, rhs: Parser.RhsType) -> Parser.AddTermType {
          return rhs + lhs
        }

      """
    XCTAssertEqual(pattern.buildEvaluatorFunction(ruleName:"addTerm"), expected)
  }

  func testBuildEvaluatorCall() {
    let pattern = Pattern(
      terms: [
        .named("lhs"),
        .quoted("+"),
        .named("rhs"),
      ],
      evaluator: "return rhs + lhs",
      id: 0
    )

    let expected = "return try recursivelyRead(addTerm: eval0AddTerm(lhs: lhs, rhs: rhs))\n"
    XCTAssertEqual(pattern.buildEvaluatorCall(ruleName:"addTerm"), expected)
  }
}
