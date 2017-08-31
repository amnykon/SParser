import Foundation

public class StringStream: Stream {
  private var position = 0
  private let string: String

  public func readChar() -> Character {
    if position == string.characters.count {
      return "\0"
    }
    defer {
      position += 1
    }
    return string[string.index(string.startIndex, offsetBy: position)]
  }

  public init(from string: String) {
    self.string = string
  }
}

