public class Thrower {
  private let parser: Parser
  private let lineNumber: Int
  private let charNumber: Int

  init(parser: Parser) {
    self.parser = parser
    lineNumber = parser.lineNumber
    charNumber = parser.charNumber + (parser.indentLevel.last ?? 0)
  }

  public func createError(message: String) -> Error {
    let errorPosition = parser.charNumber + (parser.indentLevel.last ?? 0)
    let message = """
      \(parser.lineNumber):\(errorPosition):\(message)
      \(parser.currentLine)
      \(Array(repeating: " ", count: errorPosition).joined())^"
      """
    if lineNumber == parser.lineNumber && charNumber == parser.charNumber + (parser.indentLevel.last ?? 0) {
      return ParserError(thrower: self, message: message)
    } else {
      return ParserError(thrower: nil, message: message)
    }
  }
}
