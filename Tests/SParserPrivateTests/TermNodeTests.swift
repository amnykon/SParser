import XCTest
import SParserLibs
@testable import SParserPrivate

class TermNodeTests: XCTestCase {
  func testBuildString() {
    let termNode = TermNode(term: .named("number"))

    let expected =
      "if let number = try readNumber() {\n" +
      "  try throwError(message:\"error parsing addTerm. expect \")\n" +
      "}"
    XCTAssertEqual(termNode.buildString(ruleName:"addTerm", indent: ""), expected)
  }

  func testBuildStringWithChildren() {
    let termNode = TermNode(term: .named("parentNode"))
    termNode.children = [
      TermNode(term: .quoted("term1")),
      TermNode(term: .named("term2")),
    ]

    let expected =
      "if let parentNode = try readParentNode() {\n" +
      "  if matches(string: \"term1\") {\n" +
      "    try throwError(message:\"error parsing addTerm. expect \")\n" +
      "  }\n" +
      "  if let term2 = try readTerm2() {\n" +
      "    try throwError(message:\"error parsing addTerm. expect \")\n" +
      "  }\n" +
      "  try throwError(message:\"error parsing addTerm. expect \\\"term1\\\", term2\")\n" +
      "}"
    XCTAssertEqual(termNode.buildString(ruleName:"addTerm", indent: ""), expected)
  }

  func testBuildStringWithPattern() {
    let termNode = TermNode(term: .named("number"), pattern: Pattern(terms: [], evaluator: "return []", id: 0))

    let expected =
      "if let number = try readNumber() {\n" +
      "  return try recursivelyRead(addTerm: eval0AddTerm())\n" +
      "}"
    XCTAssertEqual(termNode.buildString(ruleName:"addTerm", indent: ""), expected)
  }

  func testBuildStringWithChildrenAndPattern() {
    let termNode = TermNode(term: .named("number"), pattern: Pattern(terms: [], evaluator: "return []", id: 0))
    termNode.children = [
      TermNode(term: .quoted("term1")),
      TermNode(term: .named("term2")),
    ]

    let expected =
      "if let number = try readNumber() {\n" +
      "  if matches(string: \"term1\") {\n" +
      "    try throwError(message:\"error parsing addTerm. expect \")\n" +
      "  }\n" +
      "  if let term2 = try readTerm2() {\n" +
      "    try throwError(message:\"error parsing addTerm. expect \")\n" +
      "  }\n" +
      "  return try recursivelyRead(addTerm: eval0AddTerm())\n" +
      "}"
    XCTAssertEqual(termNode.buildString(ruleName:"addTerm", indent: ""), expected)
  }

  func testBuildStringWhileRoot() {
    let termNode = TermNode(term: nil)

    let expected =
      "  return nil\n" +
      "}"
    XCTAssertEqual(termNode.buildString(ruleName:"addTerm", indent: ""), expected)
  }

  func testBuildStringWithPatternWhileRoot() {
    let termNode = TermNode(term: nil, pattern: Pattern(terms: [], evaluator: "return []", id: 0))

    let expected =
      "  return try recursivelyRead(addTerm: eval0AddTerm())\n" +
      "}"
    XCTAssertEqual(termNode.buildString(ruleName:"addTerm", indent: ""), expected)
  }
}
