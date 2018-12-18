public struct ParserError: Error {
  public let thrower: Thrower?
  public let message: String

  init(thrower: Thrower?, message: String) {
    self.thrower = thrower
    self.message = message
  }
}
