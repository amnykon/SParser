import Foundation

extension Parser {
  public typealias LetterDigitsType = String
  public func readLetterDigits() throws -> LetterDigitsType {
    let thrower = createThrower()
    do {
      let letterDigit = try readLetterDigit()
      do {
        let letterDigits = try readLetterDigits()
        return try recursivelyRead(letterDigits: eval0LetterDigits(letterDigit: letterDigit, letterDigits: letterDigits))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing letterDigits. expect LetterDigitsType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    return try recursivelyRead(letterDigits: eval1LetterDigits())
  }
  private func recursivelyRead(letterDigits: LetterDigitsType) throws -> LetterDigitsType {
      return letterDigits
  }
  private func eval0LetterDigits(letterDigit: LetterDigitType, letterDigits: LetterDigitsType) -> LetterDigitsType {
    return String(letterDigit) + letterDigits
  }
  private func eval1LetterDigits() -> LetterDigitsType {
    return ""
  }
}
