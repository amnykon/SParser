import XCTest
@testable import SParserLibs

class StringStreamTests: XCTestCase {
  func testReadChar() {
    let stream = StringStream(from: "123456")
    XCTAssertEqual(stream.readChar(), "1")
    XCTAssertEqual(stream.readChar(), "2")
    XCTAssertEqual(stream.readChar(), "3")
    XCTAssertEqual(stream.readChar(), "4")
    XCTAssertEqual(stream.readChar(), "5")
    XCTAssertEqual(stream.readChar(), "6")
    XCTAssertEqual(stream.readChar(), "\0")
  }
}

