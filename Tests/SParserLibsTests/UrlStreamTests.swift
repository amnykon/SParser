import XCTest
@testable import SParserLibs

class UrlStreamTests: XCTestCase {
  func testReadChar() {
    let string = "123456"

    let path = FileManager.default.currentDirectoryPath
    let dirUrl = NSURL.fileURL(withPath: path)
    let fileUrl = dirUrl.appendingPathComponent("testReadChar.txt")

    try? string.write(to: fileUrl, atomically: false, encoding: .utf8)

    guard let stream = try? UrlStream(from: fileUrl) else {
      XCTAssert(false, "File not found")
      return
    }
    XCTAssertEqual(stream.readChar(), "1")
    XCTAssertEqual(stream.readChar(), "2")
    XCTAssertEqual(stream.readChar(), "3")
    XCTAssertEqual(stream.readChar(), "4")
    XCTAssertEqual(stream.readChar(), "5")
    XCTAssertEqual(stream.readChar(), "6")
    XCTAssertEqual(stream.readChar(), "\0")

    try? FileManager.default.removeItem(at:fileUrl)
  }
}

