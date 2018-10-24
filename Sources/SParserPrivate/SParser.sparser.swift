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
  private func eval0Syntax(importRule: ImportRuleType, rules: RulesType) -> SyntaxType {
    return Syntax(imports: importRule, rules: rules)
  }
  private func eval1Syntax(rules: RulesType) -> SyntaxType {
    return Syntax(imports: [], rules: rules)
  }

  private typealias ImportRuleType = [String]
  private func readImportRule() throws -> ImportRuleType? {
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
  private func eval0ImportRule(imports: ImportsType) -> ImportRuleType {
    return imports
  }

  private typealias ImportsType = [String]
  private func readImports() throws -> ImportsType? {
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
  private func eval0Imports(importFramework: ImportFrameworkType, imports: ImportsType) -> ImportsType {
    return [importFramework] + imports
  }
  private func eval1Imports() -> ImportsType {
    return []
  }

  private typealias ImportFrameworkType = String
  private func readImportFramework() throws -> ImportFrameworkType? {
    if let line = try readLine() {
      return try recursivelyRead(importFramework: eval0ImportFramework(line: line))
    }
    return nil
  }
  private func recursivelyRead(importFramework: ImportFrameworkType) throws -> ImportFrameworkType? {
    return importFramework
  }
  private func eval0ImportFramework(line: LineType) -> ImportFrameworkType {
    return line
  }

  private typealias RulesType = [Rule]
  private func readRules() throws -> RulesType? {
    return try recursivelyRead(rules: eval1Rules())
  }
  private func recursivelyRead(rules: RulesType) throws -> RulesType? {
    if let rule = try readRule() {
      return try recursivelyRead(rules: eval0Rules(rules: rules, rule: rule))
    }
    return rules
  }
  private func eval0Rules(rules: RulesType, rule: RuleType) -> RulesType {
    return rules + [rule]
  }
  private func eval1Rules() -> RulesType {
    return []
  }

  private typealias RuleType = Rule
  private func readRule() throws -> RuleType? {
    if let name = try readName() {
      if matches(string: "\n") {
        if readIndent() {
          if matches(string: "type\n") {
            if readIndent() {
              if let accessLevel = try readAccessLevel() {
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
              try throwError(message:"error parsing rule. expect AccessLevelType")
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
  private func eval0Rule(name: NameType, accessLevel: AccessLevelType, type: LineType, patterns: PatternsType) -> RuleType {
    return Rule(name: name, accessLevel: accessLevel, type: type, patterns: patterns)
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
    return try recursivelyRead(accessLevel: eval3AccessLevel())
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
  private func eval3AccessLevel() -> AccessLevelType {
    return .internal
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
  private func eval0Pattern(cws: CwsType, terms: TermsType, multiLineString: MultiLineStringType) -> PatternType {
    return Pattern(terms: terms, evaluator: multiLineString, id: 0)
  }

  private typealias TermsType = [Term]
  private func readTerms() throws -> TermsType? {
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
  private func eval0Terms(term: TermType, cws: CwsType, terms: TermsType) -> TermsType {
    return [term] + terms
  }
  private func eval1Terms() -> TermsType {
    return []
  }

  private typealias TermType = Term
  private func readTerm() throws -> TermType? {
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
  private func eval0Term() -> TermType {
    return .indent
  }
  private func eval1Term() -> TermType {
    return .dedent
  }
  private func eval2Term(name: NameType) -> TermType {
    return .type(name: nil, type: name)
  }
  private func eval3Term(name: NameType, name1: NameType) -> TermType {
    return .type(name: name, type: name1)
  }
  private func eval4Term(quotedString: QuotedStringType) -> TermType {
    return .quoted(quotedString)
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
