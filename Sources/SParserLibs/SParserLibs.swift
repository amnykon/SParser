import Foundation
extension Parser {
  public func oneOrMore<T>(_ parse: () throws -> T?) throws -> [T]? {
    let array = try zeroOrMore(parse)
    if array.isEmpty {
      return nil
    }
    return array
  }

  public func zeroOrMore<T>(_ parse: () throws -> T?) throws -> [T] {
    var array: [T] = []
    while true {
      guard let item = try parse() else {
        return array
      }
      array.append(item)
    }
  }

  public typealias QuotedStringType = String
  public func readQuotedString() throws -> QuotedStringType? {
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
    return string
  }
}

extension Parser {
  public typealias LineType = String
  public func readLine() throws -> LineType? {
    var string: String?  = ""
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
    return string
  }
}

extension Parser {
  public typealias MultiLineStringType = String
  public func readMultiLineString() throws -> MultiLineStringType? {
    let savedIsConveertingIndents = isConvertingIndents
    defer {
      isConvertingIndents = savedIsConveertingIndents
    }
    isConvertingIndents = true

    if readIndent() != true {
      return nil
    }

    isConvertingIndents = false
    var string = ""
    var prevCharWasNewline = false
    while(true) {
      if readDedent() == true {
        return string
      }
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

/*
letterDigits
  type
    String
  ::= letterDigit letterDigits
    return String(letterDigit) + letterDigits
  ::=
    return ""
*/
fileprivate func evalLetterDigits(letterDigit:Parser.LetterDigitType, letterDigits:Parser.LetterDigitsType) -> Parser.LetterDigitsType {
    return String(letterDigit) + letterDigits
}

fileprivate func evalLetterDigits() -> Parser.LetterDigitsType {
  return ""
}

extension Parser {
  public typealias LetterDigitsType = String
  public func readLetterDigits() throws -> LetterDigitsType? {
    if let letterDigit = try readLetterDigit() {
      if let letterDigits = try readLetterDigits() {
        return evalLetterDigits(letterDigit:letterDigit, letterDigits:letterDigits)
      }
    }
    return evalLetterDigits()
  }
}

extension Parser {
  public typealias LetterDigitType = Character
  public func readLetterDigit() throws -> LetterDigitType? {
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
    return char
  }
}

extension Parser {
  public typealias LetterType = Character
  public func readLetter() throws -> LetterType? {
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
    return char
  }
}

extension Parser {
  public typealias CwsType = Bool
  public func readCws() throws -> CwsType? {
    _ = try readWs()
    return true
  }
}

extension Parser {
  public typealias WsType = Bool
  public func readWs() throws -> WsType? {
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
        return nil
      }
    }
  }
}

extension Parser {
  public func matches(string: String) -> Bool {
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
    return position == string.count
  }
}

