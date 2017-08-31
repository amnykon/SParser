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
          evaluator: "return quote1"
        ),
         Pattern(
          terms: [
            .quoted("quote"),
            .quoted("quote2"),
          ],
          evaluator: "return quote2"
        ),
        Pattern(
          terms: [
            .named("name"),
          ],
          evaluator: "return []"
        ),
      ]
    )

    let expected = [
      "fileprivate func evalName() -> Parser.NameType {\n",
      "  return quote1\n",
      "}\n",
      "\n",
      "fileprivate func evalName() -> Parser.NameType {\n",
      "  return quote2\n",
      "}\n",
      "\n",
      "fileprivate func evalName(name: Parser.NameType) -> Parser.NameType {\n",
      "  return []\n",
      "}\n",
      "\n",
      "extension Parser {\n",
      "  public typealias NameType = type\n",
      "  public func readName() throws -> NameType? {\n",
      "    if matches(string: \"quote\") {\n",
      "      if matches(string: \"quote1\") {\n",
      "        return evalName()\n",
      "      }\n",
      "      if matches(string: \"quote2\") {\n",
      "        return evalName()\n",
      "      }\n",
      "    }\n",
      "    if let name = try readName() {\n",
      "      return evalName(name: name)\n",
      "    }\n",
      "    return nil\n",
      "  }\n",
      "}\n",
    ].joined()
    XCTAssertEqual(rule.buildString(), expected)
  }
}

