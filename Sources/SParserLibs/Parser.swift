import Foundation

public class Parser {

  let stream: Stream
  public var isConvertingIndents = false
  private var history: [Character]? = nil
  private var historyPosition: Int = 0

  private var isAtBeginningOfLine = true
  private var indentLevel: [Int] = []

  private var saveDepth = 0

  private enum Status {
    case none
    case indent
    case dedent
  }

  private var status = Status.none

  public func readChar() -> Character {
    if status != .none {
      return "\0"
    } 
    let readNextChar: () -> Character = {
      if let history = self.history {
        if self.historyPosition == history.count {
          let char = self.stream.readChar()
          self.history?.append(char)
          self.historyPosition += 1
          return char
        }
        defer {
          self.historyPosition += 1
          if self.historyPosition == history.count && self.saveDepth == 0 {
            self.history = nil
          }
        }
        return history[self.historyPosition]
      }
      return self.stream.readChar()
    }
    if isAtBeginningOfLine {
      isAtBeginningOfLine = false
      var level = 0
      var char: Character = "\0"

      save {
        while true {
          char = readNextChar()
          if char != " " {
            return .restore
          }
          level += 1
        }
      }

      if char == "\n" {
        level = min(level, indentLevel.last ?? 0)
        while level > 0 {
          _ = readNextChar()
          level -= 1
        }
        
        char = readNextChar()
        if char == "\n" {
          self.isAtBeginningOfLine = true
        }
        return char
      } else {
        let amountLevelChanged = level - (indentLevel.last ?? 0)
        if amountLevelChanged < 0 {
            self.indentLevel.removeLast()
            self.status = .dedent
            self.isAtBeginningOfLine = true
            return "\0"
        } else if amountLevelChanged == 0 {
          while level > 0 {
            _ = readNextChar()
            level -= 1
          }
          return readNextChar()
        } else if amountLevelChanged > 0 {
          if isConvertingIndents {
            self.indentLevel.append(level)
            self.status = .indent
            self.isAtBeginningOfLine = true
            return "\0"
          } else {
            level = indentLevel.last ?? 0
            while level > 0 {
              _ = readNextChar()
              level -= 1
            }
            return readNextChar()
          }
        }
      }
    }
    let char = readNextChar()
    if char == "\n" {
      isAtBeginningOfLine = true
    }
    return char
   
  }

  public enum SaveStatus {
    case discard
    case restore
  }

  public func save(_ block: ()->SaveStatus ) {
    saveDepth += 1
    if history == nil {
      history = []
      historyPosition = 0
    }

    let position = historyPosition
    let savedIsConvertingIndents = isConvertingIndents
    let savedIsAtBeginningOfLine = isAtBeginningOfLine
    let savedIndentLevel = indentLevel
    let status = self.status

    if block() == .restore { 
      historyPosition = position
      isConvertingIndents = savedIsConvertingIndents
      isAtBeginningOfLine = savedIsAtBeginningOfLine
      indentLevel = savedIndentLevel
      self.status = status
    }
    saveDepth -= 1
    if historyPosition == history?.count && saveDepth == 0 {
      history = nil
    }
  }

  public func save(_ block: ()throws->SaveStatus ) throws {
    saveDepth += 1
    if history == nil {
      history = []
      historyPosition = 0
    }

    let position = historyPosition
    let savedIsConvertingIndents = isConvertingIndents
    let savedIsAtBeginningOfLine = isAtBeginningOfLine
    let savedIndentLevel = indentLevel
    let status = self.status

    if try block() == .restore { 
      historyPosition = position
      isConvertingIndents = savedIsConvertingIndents
      isAtBeginningOfLine = savedIsAtBeginningOfLine
      indentLevel = savedIndentLevel
      self.status = status
    }
    saveDepth -= 1
    if historyPosition == history?.count && saveDepth == 0 {
      history = nil
    }
  }

  public typealias IndentType = Bool
  public func readIndent() throws -> IndentType? {
    if status == .none {
      save {
        _ = readChar()
        if status == .indent {
          return .discard
        } else {
          return .restore
        }
      }
    }
    if status == .indent {
      status = .none
      return true
    }
    return nil
  }

  public typealias DedentType = Bool
  public func readDedent() throws -> DedentType? {
    if status == .none {
      save {
        _ = readChar()
        if status == .dedent {
          return .discard
        } else {
          return .restore
        }
      }
    }
    if status == .dedent {
      status = .none
      return true
    }
    return nil
  }

  public init(stream: Stream) {
    self.stream = stream
  }
}

