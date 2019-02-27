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

  public typealias DoubleType = Double
  public func readDouble() throws -> DoubleType {
    let thrower = createThrower()
    do {
      let significand = try readSignificand()
      do {
        try read(string: "e")
        do {
          let exponent = try readExponent()
          return try recursivelyRead(Double: eval1Double(significand: significand, exponent: exponent))
        } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
        throw thrower.createError(message:"error parsing Double. expect ExponentType")
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      do {
        try read(string: "E")
        do {
          let exponent = try readExponent()
          return try recursivelyRead(Double: eval2Double(significand: significand, exponent: exponent))
        } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
        throw thrower.createError(message:"error parsing Double. expect ExponentType")
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      return try recursivelyRead(Double: eval0Double(significand: significand))
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing Double. expect SignificandType")
  }
  private func recursivelyRead(Double: DoubleType) throws -> DoubleType {
      return Double
  }
  private func eval0Double(significand: SignificandType) -> DoubleType {
    return significand
  }
  private func eval1Double(significand: SignificandType, exponent: ExponentType) -> DoubleType {
    return significand * pow(10.0,exponent)
  }
  private func eval2Double(significand: SignificandType, exponent: ExponentType) -> DoubleType {
    return significand * pow(10.0,exponent)
  }

  typealias ExponentType = Double
  func readExponent() throws -> ExponentType {
    let thrower = createThrower()
    do {
      try read(string: "-")
      do {
        let exponent = try readExponent()
        return try recursivelyRead(exponent: eval1Exponent(exponent: exponent))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing exponent. expect ExponentType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "+")
      do {
        let exponent = try readExponent()
        return try recursivelyRead(exponent: eval2Exponent(exponent: exponent))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing exponent. expect ExponentType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    return try recursivelyRead(exponent: eval3Exponent())
  }
  private func recursivelyRead(exponent: ExponentType) throws -> ExponentType {
    let thrower = createThrower()
    do {
      let digit = try readDigit()
      return try recursivelyRead(exponent: eval0Exponent(exponent: exponent, digit: digit))
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    return exponent
  }
  private func eval0Exponent(exponent: ExponentType, digit: DigitType) -> ExponentType {
    return exponent * 10.0 + Double(digit)
  }
  private func eval1Exponent(exponent: ExponentType) -> ExponentType {
    return -exponent
  }
  private func eval2Exponent(exponent: ExponentType) -> ExponentType {
    return exponent
  }
  private func eval3Exponent() -> ExponentType {
    return 0.0
  }

  typealias SignificandType = Double
  func readSignificand() throws -> SignificandType {
    let thrower = createThrower()
    do {
      let wholeSignificand = try readWholeSignificand()
      do {
        try read(string: ".")
        do {
          let fractionalSignificand = try readFractionalSignificand()
          return try recursivelyRead(significand: eval2Significand(wholeSignificand: wholeSignificand, fractionalSignificand: fractionalSignificand))
        } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
        throw thrower.createError(message:"error parsing significand. expect FractionalSignificandType")
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      return try recursivelyRead(significand: eval0Significand(wholeSignificand: wholeSignificand))
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: ".")
      do {
        let fractionalSignificand = try readFractionalSignificand()
        return try recursivelyRead(significand: eval1Significand(fractionalSignificand: fractionalSignificand))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing significand. expect FractionalSignificandType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing significand. expect WholeSignificandType, \".\"")
  }
  private func recursivelyRead(significand: SignificandType) throws -> SignificandType {
      return significand
  }
  private func eval0Significand(wholeSignificand: WholeSignificandType) -> SignificandType {
    return wholeSignificand
  }
  private func eval1Significand(fractionalSignificand: FractionalSignificandType) -> SignificandType {
    return fractionalSignificand
  }
  private func eval2Significand(wholeSignificand: WholeSignificandType, fractionalSignificand: FractionalSignificandType) -> SignificandType {
    return wholeSignificand + fractionalSignificand
  }

  typealias WholeSignificandType = Double
  func readWholeSignificand() throws -> WholeSignificandType {
    let thrower = createThrower()
    do {
      let digit = try readDigit()
      return try recursivelyRead(wholeSignificand: eval1WholeSignificand(digit: digit))
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing wholeSignificand. expect DigitType")
  }
  private func recursivelyRead(wholeSignificand: WholeSignificandType) throws -> WholeSignificandType {
    let thrower = createThrower()
    do {
      let digit = try readDigit()
      return try recursivelyRead(wholeSignificand: eval0WholeSignificand(wholeSignificand: wholeSignificand, digit: digit))
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    return wholeSignificand
  }
  private func eval0WholeSignificand(wholeSignificand: WholeSignificandType, digit: DigitType) -> WholeSignificandType {
    return wholeSignificand * 10.0 + Double(digit)
  }
  private func eval1WholeSignificand(digit: DigitType) -> WholeSignificandType {
    return Double(digit)
  }

  typealias FractionalSignificandType = Double
  func readFractionalSignificand() throws -> FractionalSignificandType {
    let thrower = createThrower()
    do {
      let digit = try readDigit()
      do {
        let fractionalSignificand = try readFractionalSignificand()
        return try recursivelyRead(fractionalSignificand: eval0FractionalSignificand(digit: digit, fractionalSignificand: fractionalSignificand))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing fractionalSignificand. expect FractionalSignificandType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    return try recursivelyRead(fractionalSignificand: eval1FractionalSignificand())
  }
  private func recursivelyRead(fractionalSignificand: FractionalSignificandType) throws -> FractionalSignificandType {
      return fractionalSignificand
  }
  private func eval0FractionalSignificand(digit: DigitType, fractionalSignificand: FractionalSignificandType) -> FractionalSignificandType {
    return (fractionalSignificand + Double(digit)) / 10.0
  }
  private func eval1FractionalSignificand() -> FractionalSignificandType {
    return 0.0
  }

  typealias DigitType = Int
  func readDigit() throws -> DigitType {
    let thrower = createThrower()
    do {
      try read(string: "0")
      return try recursivelyRead(digit: eval0Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "1")
      return try recursivelyRead(digit: eval1Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "2")
      return try recursivelyRead(digit: eval2Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "3")
      return try recursivelyRead(digit: eval3Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "4")
      return try recursivelyRead(digit: eval4Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "5")
      return try recursivelyRead(digit: eval5Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "6")
      return try recursivelyRead(digit: eval6Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "7")
      return try recursivelyRead(digit: eval7Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "8")
      return try recursivelyRead(digit: eval8Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
      try read(string: "9")
      return try recursivelyRead(digit: eval9Digit())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing digit. expect \"0\", \"1\", \"2\", \"3\", \"4\", \"5\", \"6\", \"7\", \"8\", \"9\"")
  }
  private func recursivelyRead(digit: DigitType) throws -> DigitType {
      return digit
  }
  private func eval0Digit() -> DigitType {
    return 0
  }
  private func eval1Digit() -> DigitType {
    return 1
  }
  private func eval2Digit() -> DigitType {
    return 2
  }
  private func eval3Digit() -> DigitType {
    return 3
  }
  private func eval4Digit() -> DigitType {
    return 4
  }
  private func eval5Digit() -> DigitType {
    return 5
  }
  private func eval6Digit() -> DigitType {
    return 6
  }
  private func eval7Digit() -> DigitType {
    return 7
  }
  private func eval8Digit() -> DigitType {
    return 8
  }
  private func eval9Digit() -> DigitType {
    return 9
  }
}
