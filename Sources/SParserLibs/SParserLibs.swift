import Foundation
extension Parser {
  public func readOneOrMore<T>(_ parse: () throws -> T) throws -> [T] {
    let array = try readZeroOrMore(parse)
    if array.isEmpty {
      throw createThrower().createError(message: "error parsing oneOrMore.")
    }
    return array
  }

  public func readZeroOrMore<T>(_ parse: () throws -> T) throws -> [T] {
    var array: [T] = []
    do {
      while true {
        array.append(try parse())
      }
    } catch let error as ParserError where error.thrower != nil {
      return array
    }
  }

  public func readOptional<T>(_ parse: () throws -> T) throws -> T? {
    do {
      return try parse()
    } catch let error as ParserError where error.thrower != nil {
      return nil
    }
  }

  public typealias QuotedStringType = String
  public func readQuotedString() throws -> QuotedStringType {
    var string: String? = ""
    save() {
      if readChar() == "\"" {
        while(true) {
          switch readChar() {
            case "\0":
              string = nil
              return .restore
            case "\"":
              return .discard
            case let char:
              string?.append(char)
          }
        }
      }
      string = nil
      return .restore
    }
    if let string = string {
      return string
    }
    throw createThrower().createError(message: "error parsing quotedString.")
  }

  public typealias LineType = String
  public func readLine() throws -> LineType {
    var string: String? = ""
    save() {
      while true {
        switch readChar() {
          case "\0":
            string = nil
            return .restore
          case "\n":
            return .discard
          case let char:
            string?.append(char)
        }
      }
    }
    if let string = string {
      return string
    }
    throw createThrower().createError(message: "error parsing line.")
  }

  public typealias MultiLineStringType = String
  public func readMultiLineString() throws -> MultiLineStringType {
    let savedIsConveertingIndents = isConvertingIndents
    defer {
      isConvertingIndents = savedIsConveertingIndents
    }
    isConvertingIndents = true

    do {
      try readIndent()
    } catch let error as ParserError where error.thrower != nil {
      throw createThrower().createError(message: "error parsing multiLineString.")
    }

    isConvertingIndents = false
    var string = ""
    var prevCharWasNewline = false
    while(true) {
      do {
        try readDedent()
        return string
      } catch let error as ParserError where error.thrower != nil {}

      switch readChar() {
      case "\0":
        /* TODO throw error */
        break;
      case "\n":
        if prevCharWasNewline {
          string.append("\n")
        }
        prevCharWasNewline = true
      case let char:
        if prevCharWasNewline {
          prevCharWasNewline = false
          string.append("\n")
        }
        string.append(char)
      }
    }
  }
}

extension Parser {
  public typealias LetterDigitType = Character
  public func readLetterDigit() throws -> LetterDigitType {
    var char: Character?
    save() {
      char = readChar()
      guard let unicodeScalar = UnicodeScalar(String(char ?? "\0")) else {
        return .discard
      }
      if CharacterSet.alphanumerics.contains(unicodeScalar) {
        return .discard
      } else {
        char = nil
        return .restore
      }
    }
    if let char = char {
      return char
    }
    throw createThrower().createError(message: "error parsing letterDigit.")
  }

  public typealias LetterType = Character
  public func readLetter() throws -> LetterType {
    var char: Character?
    save() {
      char = readChar()
      guard let unicodeScalar = UnicodeScalar(String(char ?? "\0")) else {
        char = nil
        return .restore
      }
      if CharacterSet.letters.contains(unicodeScalar) {
        return .discard
      } else {
        char = nil
        return .restore
      }
    }
    if let char = char {
      return char
    }
    throw createThrower().createError(message: "error parsing letter.")
  }

  public typealias CwsType = Bool
  public func readCws() throws -> CwsType {
    _ = try? readWs()
    return true
  }

  public typealias WsType = Bool
  public func readWs() throws -> WsType {
    var string: String = ""
    while true {
      var hasWsEnded = false
      save() {
        let char = readChar()
        guard let unicodeScalar = UnicodeScalar(String(char)) else {
          return .restore
        }
        if CharacterSet.whitespaces.contains(unicodeScalar) {
          string = string + String(char)
          return .discard
        } else {
          hasWsEnded = true
          return .restore
        }
      }
      if hasWsEnded {
        if string != "" {
          return true
        }
        throw createThrower().createError(message: "error parsing letter.")
      }
    }
  }

  public func read(string: String) throws {
    var position = 0
    save() {
      while true {
        if position == string.count {
          return .discard
        }

        if readChar() != string[string.index(string.startIndex, offsetBy: position)] {
          return .restore
        }
       position += 1
      }
    }
    if position != string.count {
      throw createThrower().createError(message: "error parsing string: \(string).")
    }
  }
}

