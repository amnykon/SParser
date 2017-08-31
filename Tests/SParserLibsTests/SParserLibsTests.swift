import XCTest
@testable import SParserLibs

class SParserLibsTests: XCTestCase {
  func testReadQuotedString() {
    let parser = Parser(stream: StringStream(from: "\"a1\"#"))
    XCTAssertEqual(try parser.readQuotedString(), "a1")
    XCTAssertEqual(try parser.readQuotedString(), nil)
  }

  func testReadLine() {
    let parser = Parser(stream: StringStream(from: "1\n234567\n8"))
    XCTAssertEqual(parser.readChar(), "1")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(try parser.readLine(), "234567")
    XCTAssertEqual(parser.readChar(), "8")
  }

  func testReadMultiLineString() {
    let parser = Parser(stream: StringStream(from: "\n  2\n  34\n  567\n8"))
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(try parser.readMultiLineString(), "2\n34\n567")
    XCTAssertEqual(try parser.readLetterDigit(), "8")
  }

  func testReadLetterDigit() {
    let parser = Parser(stream: StringStream(from: "a1#"))
    XCTAssertEqual(try parser.readLetterDigit(), "a")
    XCTAssertEqual(try parser.readLetterDigit(), "1")
    XCTAssertEqual(try parser.readLetterDigit(), nil)
  }

  func testReadLetter() {
    let parser = Parser(stream: StringStream(from: "ab1"))
    XCTAssertEqual(try parser.readLetter(), "a")
    XCTAssertEqual(try parser.readLetter(), "b")
    XCTAssertEqual(try parser.readLetter(), nil)
  }

  func testReadCws() {
    let parser = Parser(stream: StringStream(from: "  1"))
    XCTAssertEqual(try parser.readCws(), true)
    XCTAssertEqual(parser.readChar(), "1")
  }

  func testMatches() {
    let parser = Parser(stream: StringStream(from: "123456"))
    XCTAssertEqual(parser.matches(string: "234"), false)
    XCTAssertEqual(parser.matches(string: "1234"), true)
    XCTAssertEqual(parser.matches(string: "234"), false)
    XCTAssertEqual(parser.matches(string: "56"), true)
  }
}

