public struct ParserError: Error {
  public let message: String
  public init(message: String) {
    self.message = message
  }
}
