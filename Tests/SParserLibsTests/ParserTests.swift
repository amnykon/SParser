import XCTest
@testable import SParserLibs

class ParserTests: XCTestCase {
  func testReadChar() {
    let parser = Parser(stream:StringStream(from: "123456"))
    XCTAssertEqual(parser.readChar(), "1")
    XCTAssertEqual(parser.readChar(), "2")
    XCTAssertEqual(parser.readChar(), "3")
    XCTAssertEqual(parser.readChar(), "4")
    XCTAssertEqual(parser.readChar(), "5")
    XCTAssertEqual(parser.readChar(), "6")
    XCTAssertEqual(parser.readChar(), "\0")
  }

  func testSaveRestore() {
    let parser = Parser(stream:StringStream(from: "12"))
    XCTAssertEqual(parser.readChar(), "1")
    parser.save {
      XCTAssertEqual(parser.readChar(), "2")
      return .restore
    }
    XCTAssertEqual(parser.readChar(), "2")
  }

  func testSaveDiscard() {
    let parser = Parser(stream:StringStream(from: "123"))
    XCTAssertEqual(parser.readChar(), "1")
    parser.save {
      XCTAssertEqual(parser.readChar(), "2")
      return .discard
    }
    XCTAssertEqual(parser.readChar(), "3")
  }

  func testSaveSaveDiscardRestore() {
    let parser = Parser(stream:StringStream(from: "1234"))
    XCTAssertEqual(parser.readChar(), "1")
    parser.save {
      XCTAssertEqual(parser.readChar(), "2")
      parser.save {
        XCTAssertEqual(parser.readChar(), "3")
        return .discard
      }
      XCTAssertEqual(parser.readChar(), "4")
      return .restore
    }
    XCTAssertEqual(parser.readChar(), "2")
  }

  func testSaveSaveRestoreDiscard() {
    let parser = Parser(stream:StringStream(from: "1234"))
    XCTAssertEqual(parser.readChar(), "1")
    parser.save {
      XCTAssertEqual(parser.readChar(), "2")
      parser.save{
        XCTAssertEqual(parser.readChar(), "3")
        return .restore
      }
      XCTAssertEqual(parser.readChar(), "3")
      return .discard
    }
    XCTAssertEqual(parser.readChar(), "4")
  }

  func testIndentIndentDedentDedent() {
    let parser = Parser(stream:StringStream(from: "  1\n    2\n  3\n4"))
    parser.isConvertingIndents = true
    XCTAssertEqual(parser.readIndent(), true)
    XCTAssertEqual(parser.readChar(), "1")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readIndent(), true)
    XCTAssertEqual(parser.readChar(), "2")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readDedent(), true)
    XCTAssertEqual(parser.readChar(), "3")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readDedent(), true)
    XCTAssertEqual(parser.readChar(), "4")
  }

  func testIndentIsNotConvertingIndentsIndentDedentDedent() {
    let parser = Parser(stream:StringStream(from: "  1\n    2\n  3\n4"))
    parser.isConvertingIndents = true
    XCTAssertEqual(parser.readIndent(), true)
    XCTAssertEqual(parser.readChar(), "1")
    XCTAssertEqual(parser.readChar(), "\n")
    parser.isConvertingIndents = false
    XCTAssertEqual(parser.readIndent(), false)
    XCTAssertEqual(parser.readChar(), " ")
    XCTAssertEqual(parser.readChar(), " ")
    XCTAssertEqual(parser.readChar(), "2")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readDedent(), false)
    XCTAssertEqual(parser.readChar(), "3")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readDedent(), true)
    XCTAssertEqual(parser.readChar(), "4")
  }

  func testIndentSaveDedentRestoreDedent() throws {
    let parser = Parser(stream:StringStream(from: "  1\n2"))
    parser.isConvertingIndents = true
    XCTAssertEqual(parser.readIndent(), true)
    XCTAssertEqual(parser.readChar(), "1")
    XCTAssertEqual(parser.readChar(), "\n")
    parser.save {
      XCTAssertEqual(parser.readDedent(), true)
      XCTAssertEqual(parser.readChar(), "2")
      return .restore
    }
    XCTAssertEqual(parser.readDedent(), true)
    XCTAssertEqual(parser.readChar(), "2")
  }

  func testIndentBlankLineDedent() {
    let parser = Parser(stream:StringStream(from: "  1\n\n"))
    parser.isConvertingIndents = true
    XCTAssertEqual(parser.readIndent(), true)
    XCTAssertEqual(parser.readChar(), "1")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readDedent(), true)
  }
  func testIndentBlankLineWithSpacesDedent() {
    let parser = Parser(stream:StringStream(from: "  1\n    \n"))
    parser.isConvertingIndents = true
    XCTAssertEqual(parser.readIndent(), true)
    XCTAssertEqual(parser.readChar(), "1")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readChar(), " ")
    XCTAssertEqual(parser.readChar(), " ")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readDedent(), true)
  }
  func testIndentIndentDoubleDedent() {
    let parser = Parser(stream:StringStream(from: "  1\n    2\n"))
    parser.isConvertingIndents = true
    XCTAssertEqual(parser.readIndent(), true)
    XCTAssertEqual(parser.readChar(), "1")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readIndent(), true)
    XCTAssertEqual(parser.readChar(), "2")
    XCTAssertEqual(parser.readChar(), "\n")
    XCTAssertEqual(parser.readDedent(), true)
    XCTAssertEqual(parser.readDedent(), true)
  }
}

