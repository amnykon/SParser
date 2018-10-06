import XCTest
import SParserLibs
@testable import SParserPrivate

class RuleTests: XCTestCase {
  func testBuildString() {
    let rule = Rule(
      name: "name",
      type: "type",
      patterns: [
        Pattern(
          terms: [
            .quoted("quote"),
            .quoted("quote1"),
          ],
          evaluator: "return quote1",
          id: 0
        ),
         Pattern(
          terms: [
            .quoted("quote"),
            .quoted("quote2"),
          ],
          evaluator: "return quote2",
          id: 1
        ),
        Pattern(
          terms: [
            .named("name1"),
          ],
          evaluator: "return []",
          id: 2
        ),
      ]
    )

    let expected = """
      public typealias NameType = type
      public func readName() throws -> NameType? {
        if matches(string: "quote") {
          if matches(string: "quote1") {
            return try recursivelyRead(name: eval0Name())
          }
          if matches(string: "quote2") {
            return try recursivelyRead(name: eval1Name())
          }
          try throwError(message:"error parsing name. expect \\"quote1\\", \\"quote2\\"")
        }
        if let name1 = try readName1() {
          return try recursivelyRead(name: eval2Name(name1: name1))
        }
        return nil
      }

      private func recursivelyRead(name: NameType) throws -> NameType? {
        return name
      }

      fileprivate func eval0Name() -> Parser.NameType {
        return quote1
      }

      fileprivate func eval1Name() -> Parser.NameType {
        return quote2
      }

      fileprivate func eval2Name(name1: Parser.Name1Type) -> Parser.NameType {
        return []
      }

    """
        XCTAssertEqual(rule.buildString(), expected)
  }
}

