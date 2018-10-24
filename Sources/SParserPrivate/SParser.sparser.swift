import Foundation
import SParserLibs

extension Parser {
  public typealias SyntaxType = Syntax
  public func readSyntax() throws -> SyntaxType? {
    if let importRule = try readImportRule() {
      if let rules = try readRules() {
        return try recursivelyRead(syntax: eval0Syntax(importRule: importRule, rules: rules))
      }
      try throwError(message:"error parsing syntax. expect RulesType")
    }
    if let rules = try readRules() {
      return try recursivelyRead(syntax: eval1Syntax(rules: rules))
    }
    return nil
  }
  private func recursivelyRead(syntax: SyntaxType) throws -> SyntaxType? {
    return syntax
  }
  fileprivate func eval0Syntax(importRule: ImportRuleType, rules: RulesType) -> SyntaxType {
    return Syntax(imports: importRule, rules: rules)
  }
  fileprivate func eval1Syntax(rules: RulesType) -> SyntaxType {
    return Syntax(imports: [], rules: rules)
  }

  public typealias ImportRuleType = [String]
  public func readImportRule() throws -> ImportRuleType? {
    if matches(string: "imports\n") {
      if readIndent() {
        if let imports = try readImports() {
          if readDedent() {
            return try recursivelyRead(importRule: eval0ImportRule(imports: imports))
          }
          try throwError(message:"error parsing importRule. expect ")
        }
        try throwError(message:"error parsing importRule. expect ImportsType")
      }
      try throwError(message:"error parsing importRule. expect ")
    }
    return nil
  }
  private func recursivelyRead(importRule: ImportRuleType) throws -> ImportRuleType? {
    return importRule
  }
  fileprivate func eval0ImportRule(imports: ImportsType) -> ImportRuleType {
    return imports
  }

  public typealias ImportsType = [String]
  public func readImports() throws -> ImportsType? {
    if let importFramework = try readImportFramework() {
      if let imports = try readImports() {
        return try recursivelyRead(imports: eval0Imports(importFramework: importFramework, imports: imports))
      }
      try throwError(message:"error parsing imports. expect ImportsType")
    }
    return try recursivelyRead(imports: eval1Imports())
  }
  private func recursivelyRead(imports: ImportsType) throws -> ImportsType? {
    return imports
  }
  fileprivate func eval0Imports(importFramework: ImportFrameworkType, imports: ImportsType) -> ImportsType {
    return [importFramework] + imports
  }
  fileprivate func eval1Imports() -> ImportsType {
    return []
  }

  public typealias ImportFrameworkType = String
  public func readImportFramework() throws -> ImportFrameworkType? {
    if let line = try readLine() {
      return try recursivelyRead(importFramework: eval0ImportFramework(line: line))
    }
    return nil
  }
  private func recursivelyRead(importFramework: ImportFrameworkType) throws -> ImportFrameworkType? {
    return importFramework
  }
  fileprivate func eval0ImportFramework(line: LineType) -> ImportFrameworkType {
    return line
  }

  public typealias RulesType = [Rule]
  public func readRules() throws -> RulesType? {
    return try recursivelyRead(rules: eval1Rules())
  }
  private func recursivelyRead(rules: RulesType) throws -> RulesType? {
    if let rule = try readRule() {
      return try recursivelyRead(rules: eval0Rules(rules: rules, rule: rule))
    }
    return rules
  }
  fileprivate func eval0Rules(rules: RulesType, rule: RuleType) -> RulesType {
    return rules + [rule]
  }
  fileprivate func eval1Rules() -> RulesType {
    return []
  }

  public typealias RuleType = Rule
  public func readRule() throws -> RuleType? {
    if let name = try readName() {
      if matches(string: "\n") {
        if readIndent() {
          if let type = try readType() {
            if let patterns = try readPatterns() {
              if readDedent() {
                return try recursivelyRead(rule: eval0Rule(name: name, type: type, patterns: patterns))
              }
              try throwError(message:"error parsing rule. expect ")
            }
            try throwError(message:"error parsing rule. expect PatternsType")
          }
          try throwError(message:"error parsing rule. expect TypeType")
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
  fileprivate func eval0Rule(name: NameType, type: TypeType, patterns: PatternsType) -> RuleType {
    return Rule(name: name, type: type, patterns: patterns)
  }

  public typealias TypeType = String
  public func readType() throws -> TypeType? {
    if matches(string: "type\n") {
      if readIndent() {
        if let line = try readLine() {
          if readDedent() {
            return try recursivelyRead(type: eval0Type(line: line))
          }
          try throwError(message:"error parsing type. expect ")
        }
        try throwError(message:"error parsing type. expect LineType")
      }
      try throwError(message:"error parsing type. expect ")
    }
    return nil
  }
  private func recursivelyRead(type: TypeType) throws -> TypeType? {
    return type
  }
  fileprivate func eval0Type(line: LineType) -> TypeType {
    return line
  }

  public typealias PatternsType = [Pattern]
  public func readPatterns() throws -> PatternsType? {
    return try recursivelyRead(patterns: eval1Patterns())
  }
  private func recursivelyRead(patterns: PatternsType) throws -> PatternsType? {
    if let pattern = try readPattern() {
      return try recursivelyRead(patterns: eval0Patterns(patterns: patterns, pattern: pattern))
    }
    return patterns
  }
  fileprivate func eval0Patterns(patterns: PatternsType, pattern: PatternType) -> PatternsType {
    return patterns + [Pattern(terms: pattern.terms, evaluator: pattern.evaluator, id: patterns.count)]
  }
  fileprivate func eval1Patterns() -> PatternsType {
    return []
  }

  public typealias PatternType = Pattern
  public func readPattern() throws -> PatternType? {
    if matches(string: "::=") {
      if let cws = try readCws() {
        if let terms = try readTerms() {
          if matches(string: "\n") {
            if let multiLineString = try readMultiLineString() {
              return try recursivelyRead(pattern: eval0Pattern(cws: cws, terms: terms, multiLineString: multiLineString))
            }
            try throwError(message:"error parsing pattern. expect MultiLineStringType")
          }
          try throwError(message:"error parsing pattern. expect \"\n\"")
        }
        try throwError(message:"error parsing pattern. expect TermsType")
      }
      try throwError(message:"error parsing pattern. expect CwsType")
    }
    return nil
  }
  private func recursivelyRead(pattern: PatternType) throws -> PatternType? {
    return pattern
  }
  fileprivate func eval0Pattern(cws: CwsType, terms: TermsType, multiLineString: MultiLineStringType) -> PatternType {
    return Pattern(terms: terms, evaluator: multiLineString, id: 0)
  }

  public typealias TermsType = [Term]
  public func readTerms() throws -> TermsType? {
    if let term = try readTerm() {
      if let cws = try readCws() {
        if let terms = try readTerms() {
          return try recursivelyRead(terms: eval0Terms(term: term, cws: cws, terms: terms))
        }
        try throwError(message:"error parsing terms. expect TermsType")
      }
      try throwError(message:"error parsing terms. expect CwsType")
    }
    return try recursivelyRead(terms: eval1Terms())
  }
  private func recursivelyRead(terms: TermsType) throws -> TermsType? {
    return terms
  }
  fileprivate func eval0Terms(term: TermType, cws: CwsType, terms: TermsType) -> TermsType {
    return [term] + terms
  }
  fileprivate func eval1Terms() -> TermsType {
    return []
  }

  public typealias TermType = Term
  public func readTerm() throws -> TermType? {
    if matches(string: "indent") {
      return try recursivelyRead(term: eval0Term())
    }
    if matches(string: "dedent") {
      return try recursivelyRead(term: eval1Term())
    }
    if let name = try readName() {
      if matches(string: ":") {
        if let name1 = try readName() {
          return try recursivelyRead(term: eval3Term(name: name, name1: name1))
        }
        try throwError(message:"error parsing term. expect NameType")
      }
      return try recursivelyRead(term: eval2Term(name: name))
    }
    if let quotedString = try readQuotedString() {
      return try recursivelyRead(term: eval4Term(quotedString: quotedString))
    }
    return nil
  }
  private func recursivelyRead(term: TermType) throws -> TermType? {
    return term
  }
  fileprivate func eval0Term() -> TermType {
    return .indent
  }
  fileprivate func eval1Term() -> TermType {
    return .dedent
  }
  fileprivate func eval2Term(name: NameType) -> TermType {
    return .type(name: nil, type: name)
  }
  fileprivate func eval3Term(name: NameType, name1: NameType) -> TermType {
    return .type(name: name, type: name1)
  }
  fileprivate func eval4Term(quotedString: QuotedStringType) -> TermType {
    return .quoted(quotedString)
  }

  public typealias NameType = String
  public func readName() throws -> NameType? {
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
  fileprivate func eval0Name(letter: LetterType, letterDigits: LetterDigitsType) -> NameType {
    return String(letter) + letterDigits

  }
}
