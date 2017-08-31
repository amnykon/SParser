import XCTest
import SParserLibs
@testable import SParserPrivate

class SParserTests: XCTestCase {
  func testReadSyntax() throws {
    let parser = Parser(stream: StringStream(from: "ruleName\n  type\n    ruleType\n  ::= \"123\" F12\n    evaluator1\n"))
    parser.isConvertingIndents = true
    let syntax = try parser.readSyntax()
    XCTAssertEqual(syntax?[0].patterns[0].terms.count, 2)
    XCTAssertEqual(syntax?[0].patterns[0].terms[0], Term.quoted("123"))
    XCTAssertEqual(syntax?[0].patterns[0].terms[1], Term.named("F12"))
    XCTAssertEqual(syntax?[0].patterns[0].evaluator, "evaluator1")
  }

  func testReadRules() throws {
    let parser = Parser(stream: StringStream(from: "ruleName\n  type\n    ruleType\n  ::= \"123\" F12\n    evaluator1\nruleName1\n  type\n    ruleType\n  ::= \"124\" F13\n    evaluator2\n"))
    parser.isConvertingIndents = true
    let rules = try parser.readRules()
    XCTAssertEqual(rules?[0].name, "ruleName")
    XCTAssertEqual(rules?[0].patterns[0].terms.count, 2)
    XCTAssertEqual(rules?[0].patterns[0].terms[0], Term.quoted("123"))
    XCTAssertEqual(rules?[0].patterns[0].terms[1], Term.named("F12"))
    XCTAssertEqual(rules?[0].patterns[0].evaluator, "evaluator1")
    XCTAssertEqual(rules?[1].name, "ruleName1")
    XCTAssertEqual(rules?[1].patterns[0].terms.count, 2)
    XCTAssertEqual(rules?[1].patterns[0].terms[0], Term.quoted("124"))
    XCTAssertEqual(rules?[1].patterns[0].terms[1], Term.named("F13"))
    XCTAssertEqual(rules?[1].patterns[0].evaluator, "evaluator2")
  }

  func testReadRule() throws {
    let parser = Parser(stream: StringStream(from: "ruleName\n  type\n    ruleType\n  ::= \"123\" F12\n    evaluator1\n1"))
    parser.isConvertingIndents = true
    let rule = try parser.readRule()
    XCTAssertEqual(rule?.name, "ruleName")
    XCTAssertEqual(rule?.patterns[0].terms.count, 2)
    XCTAssertEqual(rule?.patterns[0].terms[0], Term.quoted("123"))
    XCTAssertEqual(rule?.patterns[0].terms[1], Term.named("F12"))
    XCTAssertEqual(rule?.patterns[0].evaluator, "evaluator1")
    XCTAssertEqual(parser.readChar(), "1")
  }


  func testReadType() throws {
    let parser = Parser(stream: StringStream(from: "type\n aType\n"))
    parser.isConvertingIndents = true
    let type = try parser.readType()
    XCTAssertEqual(type, "aType")
  }

  func testReadPatterns() throws {
    let parser = Parser(stream: StringStream(from: "::= \"123\" F12\n  evaluator1\n::= \"456\" F78\n  evaluator2\n"))
    parser.isConvertingIndents = true
    let patterns = try parser.readPatterns()
    XCTAssertEqual(patterns?[0].terms.count, 2)
    XCTAssertEqual(patterns?[0].terms[0], Term.quoted("123"))
    XCTAssertEqual(patterns?[0].terms[1], Term.named("F12"))
    XCTAssertEqual(patterns?[0].evaluator, "evaluator1")
    XCTAssertEqual(patterns?[1].terms.count, 2)
    XCTAssertEqual(patterns?[1].terms[0], Term.quoted("456"))
    XCTAssertEqual(patterns?[1].terms[1], Term.named("F78"))
    XCTAssertEqual(patterns?[1].evaluator, "evaluator2")
  }

  func testReadPattern() throws {
    let parser = Parser(stream: StringStream(from: "::= \"123\" F12\n  evaluator\n1"))
    parser.isConvertingIndents = true
    let pattern = try parser.readPattern()
    XCTAssertEqual(pattern?.terms.count, 2)
    XCTAssertEqual(pattern?.terms[0], Term.quoted("123"))
    XCTAssertEqual(pattern?.terms[1], Term.named("F12"))
    XCTAssertEqual(pattern?.evaluator, "evaluator")
    XCTAssertEqual(parser.readChar(), "1")
  }

  func testReadTerms() throws {
    let parser = Parser(stream: StringStream(from: "\"123\" F12\n"))
    let terms = try parser.readTerms()
    XCTAssertEqual(terms?.count, 2)
    XCTAssertEqual(terms?[0], Term.quoted("123"))
    XCTAssertEqual(terms?[1], Term.named("F12"))
    XCTAssertEqual(parser.readChar(), "\n")
  }

  func testReadTerm() throws {
    let parser = Parser(stream: StringStream(from: "\"123\"F12\n"))
    XCTAssertEqual(try parser.readTerm(), Term.quoted("123"))
    XCTAssertEqual(try parser.readTerm(), Term.named("F12"))
    XCTAssertEqual(try parser.readTerm(), nil)
    XCTAssertEqual(parser.readChar(), "\n")
  }

  func testReadName() throws {
    let parser = Parser(stream: StringStream(from: "2S12s\n"))
    XCTAssertEqual(try parser.readName(), nil)
    XCTAssertEqual(parser.readChar(), "2")
    XCTAssertEqual(try parser.readName(), "S12s")
    XCTAssertEqual(try parser.readName(), nil)
    XCTAssertEqual(parser.readChar(), "\n")
  }
}

