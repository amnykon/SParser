import Foundation
import SParserLibs

extension Parser {
  public typealias SyntaxType = Syntax
  public func readSyntax() throws -> SyntaxType? {
    do { let importRule = try readImportRule()
      do { let rule = try zeroOrMore({try readRule()})
        return try recursivelyRead(syntax: eval0Syntax(importRule: importRule, rules: rule))
      }
    }
  }
  private func recursivelyRead(syntax: SyntaxType) throws -> SyntaxType? {
    return syntax
  }
  private func eval0Syntax(importRule: ImportRuleType?, rules: [RuleType]) -> SyntaxType {
    return Syntax(imports: importRule ?? [], rules: rules)
  }

  private typealias ImportRuleType = [String]
  private func readImportRule() throws -> ImportRuleType? {
    if matches(string: "imports\n") {
      if readIndent() {
        if let line = try oneOrMore({try readLine()}) {
          if readDedent() {
            return try recursivelyRead(importRule: eval0ImportRule(imports: line))
          }
          try throwError(message:"error parsing importRule. expect ")
        }
        try throwError(message:"error parsing importRule. expect [LineType]")
      }
      try throwError(message:"error parsing importRule. expect ")
    }
    return nil
  }
  private func recursivelyRead(importRule: ImportRuleType) throws -> ImportRuleType? {
    return importRule
  }
  private func eval0ImportRule(imports: [LineType]) -> ImportRuleType {
    return imports
  }

  private typealias RuleType = Rule
  private func readRule() throws -> RuleType? {
    if let name = try readName() {
      if matches(string: "\n") {
        if readIndent() {
          if matches(string: "type\n") {
            if readIndent() {
              do { let accessLevel = try readAccessLevel()
                if let line = try readLine() {
                  if readDedent() {
                    if let patterns = try readPatterns() {
                      if readDedent() {
                        return try recursivelyRead(rule: eval0Rule(name: name, accessLevel: accessLevel, type: line, patterns: patterns))
                      }
                      try throwError(message:"error parsing rule. expect ")
                    }
                    try throwError(message:"error parsing rule. expect PatternsType")
                  }
                  try throwError(message:"error parsing rule. expect ")
                }
                try throwError(message:"error parsing rule. expect LineType")
              }
            }
            try throwError(message:"error parsing rule. expect ")
          }
          try throwError(message:"error parsing rule. expect \"type\n\"")
        }
        try throwError(message:"error parsing rule. expect ")
      }
      try throwError(message:"error parsing rule. expect \"\n\"")
    }
    return nil
  }
  private func recursivelyRead(rule: RuleType) throws -> RuleType? {
    return rule
  }
  private func eval0Rule(name: NameType, accessLevel: AccessLevelType?, type: LineType, patterns: PatternsType) -> RuleType {
    return Rule(name: name, accessLevel: accessLevel ?? .internal, type: type, patterns: patterns)
  }

  private typealias AccessLevelType = AccessLevel
  private func readAccessLevel() throws -> AccessLevelType? {
    if matches(string: "public ") {
      return try recursivelyRead(accessLevel: eval0AccessLevel())
    }
    if matches(string: "internal ") {
      return try recursivelyRead(accessLevel: eval1AccessLevel())
    }
    if matches(string: "private ") {
      return try recursivelyRead(accessLevel: eval2AccessLevel())
    }
    return nil
  }
  private func recursivelyRead(accessLevel: AccessLevelType) throws -> AccessLevelType? {
    return accessLevel
  }
  private func eval0AccessLevel() -> AccessLevelType {
    return .public
  }
  private func eval1AccessLevel() -> AccessLevelType {
    return .internal
  }
  private func eval2AccessLevel() -> AccessLevelType {
    return .private
  }

  private typealias PatternsType = [Pattern]
  private func readPatterns() throws -> PatternsType? {
    return try recursivelyRead(patterns: eval1Patterns())
  }
  private func recursivelyRead(patterns: PatternsType) throws -> PatternsType? {
    if let pattern = try readPattern() {
      return try recursivelyRead(patterns: eval0Patterns(patterns: patterns, pattern: pattern))
    }
    return patterns
  }
  private func eval0Patterns(patterns: PatternsType, pattern: PatternType) -> PatternsType {
    return patterns + [Pattern(terms: pattern.terms, evaluator: pattern.evaluator, id: patterns.count)]
  }
  private func eval1Patterns() -> PatternsType {
    return []
  }

  private typealias PatternType = Pattern
  private func readPattern() throws -> PatternType? {
    if matches(string: "::=") {
      if let cws = try readCws() {
        do { let term = try zeroOrMore({try readTerm()})
          if matches(string: "\n") {
            if let multiLineString = try readMultiLineString() {
              return try recursivelyRead(pattern: eval0Pattern(cws: cws, terms: term, multiLineString: multiLineString))
            }
            try throwError(message:"error parsing pattern. expect MultiLineStringType")
          }
          try throwError(message:"error parsing pattern. expect \"\n\"")
        }
      }
      try throwError(message:"error parsing pattern. expect CwsType")
    }
    return nil
  }
  private func recursivelyRead(pattern: PatternType) throws -> PatternType? {
    return pattern
  }
  private func eval0Pattern(cws: CwsType, terms: [TermType], multiLineString: MultiLineStringType) -> PatternType {
    return Pattern(terms: terms, evaluator: multiLineString, id: 0)
  }

  private typealias TermType = Term
  private func readTerm() throws -> TermType? {
    if matches(string: "indent") {
      if let cws = try readCws() {
        return try recursivelyRead(term: eval0Term(cws: cws))
      }
      try throwError(message:"error parsing term. expect CwsType")
    }
    if matches(string: "dedent") {
      if let cws = try readCws() {
        return try recursivelyRead(term: eval1Term(cws: cws))
      }
      try throwError(message:"error parsing term. expect CwsType")
    }
    if let name = try readName() {
      if matches(string: ":") {
        if let name1 = try readName() {
          do { let termModifier = try readTermModifier()
            if let cws = try readCws() {
              return try recursivelyRead(term: eval2Term(name: name, type: name1, termModifier: termModifier, cws: cws))
            }
            try throwError(message:"error parsing term. expect CwsType")
          }
        }
        try throwError(message:"error parsing term. expect NameType")
      }
      do { let termModifier = try readTermModifier()
        if let cws = try readCws() {
          return try recursivelyRead(term: eval3Term(type: name, termModifier: termModifier, cws: cws))
        }
        try throwError(message:"error parsing term. expect CwsType")
      }
    }
    if let quotedString = try readQuotedString() {
      if let cws = try readCws() {
        return try recursivelyRead(term: eval4Term(quotedString: quotedString, cws: cws))
      }
      try throwError(message:"error parsing term. expect CwsType")
    }
    return nil
  }
  private func recursivelyRead(term: TermType) throws -> TermType? {
    return term
  }
  private func eval0Term(cws: CwsType) -> TermType {
    return .indent
  }
  private func eval1Term(cws: CwsType) -> TermType {
    return .dedent
  }
  private func eval2Term(name: NameType, type: NameType, termModifier: TermModifierType?, cws: CwsType) -> TermType {
    return .type(name: name, type: type, modifier: termModifier ?? .one)
  }
  private func eval3Term(type: NameType, termModifier: TermModifierType?, cws: CwsType) -> TermType {
    return .type(name: nil, type: type, modifier: termModifier ?? .one)
  }
  private func eval4Term(quotedString: QuotedStringType, cws: CwsType) -> TermType {
    return .quoted(quotedString)
  }

  private typealias TermModifierType = TermModifier
  private func readTermModifier() throws -> TermModifierType? {
    if matches(string: "?") {
      return try recursivelyRead(termModifier: eval0TermModifier())
    }
    if matches(string: "+") {
      return try recursivelyRead(termModifier: eval1TermModifier())
    }
    if matches(string: "*") {
      return try recursivelyRead(termModifier: eval2TermModifier())
    }
    return nil
  }
  private func recursivelyRead(termModifier: TermModifierType) throws -> TermModifierType? {
    return termModifier
  }
  private func eval0TermModifier() -> TermModifierType {
    return .optional
  }
  private func eval1TermModifier() -> TermModifierType {
    return .oneOrMore
  }
  private func eval2TermModifier() -> TermModifierType {
    return .zeroOrMore
  }

  private typealias NameType = String
  private func readName() throws -> NameType? {
    if let letter = try readLetter() {
      if let letterDigits = try readLetterDigits() {
        return try recursivelyRead(name: eval0Name(letter: letter, letterDigits: letterDigits))
      }
      try throwError(message:"error parsing name. expect LetterDigitsType")
    }
    return nil
  }
  private func recursivelyRead(name: NameType) throws -> NameType? {
    return name
  }
  private func eval0Name(letter: LetterType, letterDigits: LetterDigitsType) -> NameType {
    return String(letter) + letterDigits

  }
}
