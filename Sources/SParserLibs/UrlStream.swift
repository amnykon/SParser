import Foundation

public class UrlStream: Stream {
  private let stream: Stream

  public func readChar() -> Character {
    return stream.readChar()
  }

  public init(from url: URL, encoding: String.Encoding = .utf8) throws {
    let string = try String(contentsOf: url, encoding: encoding)
    stream = StringStream(from: string)
  }
}

