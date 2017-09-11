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

    let expected = [
      "fileprivate func eval0Name() -> Parser.NameType {\n",
      "  return quote1\n",
      "}\n",
      "\n",
      "fileprivate func eval1Name() -> Parser.NameType {\n",
      "  return quote2\n",
      "}\n",
      "\n",
      "fileprivate func eval2Name(name1: Parser.Name1Type) -> Parser.NameType {\n",
      "  return []\n",
      "}\n",
      "\n",
      "extension Parser {\n",
      "  public typealias NameType = type\n",
      "  private func recursivelyRead(name: NameType) throws -> NameType? {\n",
      "    return name\n",
      "  }\n",
      "  public func readName() throws -> NameType? {\n",
      "    if matches(string: \"quote\") {\n",
      "      if matches(string: \"quote1\") {\n",
      "        return try recursivelyRead(name: eval0Name())\n",
      "      }\n",
      "      if matches(string: \"quote2\") {\n",
      "        return try recursivelyRead(name: eval1Name())\n",
      "      }\n",
      "      try throwError(message:\"error parsing name. expect \\\"quote1\\\", \\\"quote2\\\"\")\n",
      "    }\n",
      "    if let name1 = try readName1() {\n",
      "      return try recursivelyRead(name: eval2Name(name1: name1))\n",
      "    }\n",
      "    return nil\n",
      "  }\n",
      "}\n",
    ].joined()
    XCTAssertEqual(rule.buildString(), expected)
  }
}

