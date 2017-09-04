import Foundation
import SParserLibs
fileprivate func evalSyntax(importRule: Parser.ImportRuleType, rules: Parser.RulesType) -> Parser.SyntaxType {
  return Syntax(imports: importRule, rules: rules)
}

fileprivate func evalSyntax(rules: Parser.RulesType) -> Parser.SyntaxType {
  return Syntax(imports: [], rules: rules)
}

extension Parser {
  public typealias SyntaxType = Syntax
  private func recursivelyRead(syntax: SyntaxType) throws -> SyntaxType? {
    return syntax
  }
  public func readSyntax() throws -> SyntaxType? {
    if let importRule = try readImportRule() {
      if let rules = try readRules() {
        return try recursivelyRead(syntax: evalSyntax(importRule: importRule, rules: rules))
      }
      try throwError(message:"error parsing syntax. expect rules")
    }
    if let rules = try readRules() {
      return try recursivelyRead(syntax: evalSyntax(rules: rules))
    }
    return nil
  }
}

fileprivate func evalImportRule(indent: Parser.IndentType, imports: Parser.ImportsType, dedent: Parser.DedentType) -> Parser.ImportRuleType {
  return imports
}

extension Parser {
  public typealias ImportRuleType = [String]
  private func recursivelyRead(importRule: ImportRuleType) throws -> ImportRuleType? {
    return importRule
  }
  public func readImportRule() throws -> ImportRuleType? {
    if matches(string: "imports\n") {
      if let indent = try readIndent() {
        if let imports = try readImports() {
          if let dedent = try readDedent() {
            return try recursivelyRead(importRule: evalImportRule(indent: indent, imports: imports, dedent: dedent))
          }
          try throwError(message:"error parsing importRule. expect dedent")
        }
        try throwError(message:"error parsing importRule. expect imports")
      }
      try throwError(message:"error parsing importRule. expect indent")
    }
    return nil
  }
}

fileprivate func evalImports(importFramework: Parser.ImportFrameworkType, imports: Parser.ImportsType) -> Parser.ImportsType {
  return [importFramework] + imports
}

fileprivate func evalImports() -> Parser.ImportsType {
  return []
}

extension Parser {
  public typealias ImportsType = [String]
  private func recursivelyRead(imports: ImportsType) throws -> ImportsType? {
    return imports
  }
  public func readImports() throws -> ImportsType? {
    if let importFramework = try readImportFramework() {
      if let imports = try readImports() {
        return try recursivelyRead(imports: evalImports(importFramework: importFramework, imports: imports))
      }
      try throwError(message:"error parsing imports. expect imports")
    }
    return try recursivelyRead(imports: evalImports())
  }
}

fileprivate func evalImportFramework(line: Parser.LineType) -> Parser.ImportFrameworkType {
  return line
}

extension Parser {
  public typealias ImportFrameworkType = String
  private func recursivelyRead(importFramework: ImportFrameworkType) throws -> ImportFrameworkType? {
    return importFramework
  }
  public func readImportFramework() throws -> ImportFrameworkType? {
    if let line = try readLine() {
      return try recursivelyRead(importFramework: evalImportFramework(line: line))
    }
    return nil
  }
}

fileprivate func evalRules(rules: Parser.RulesType, rule: Parser.RuleType) -> Parser.RulesType {
  return rules + [rule]
}

fileprivate func evalRules() -> Parser.RulesType {
  return []
}

extension Parser {
  public typealias RulesType = [Rule]
  private func recursivelyRead(rules: RulesType) throws -> RulesType? {
    if let rule = try readRule() {
      return try recursivelyRead(rules: evalRules(rules: rules, rule: rule))
    }
    return rules
  }
  public func readRules() throws -> RulesType? {
    return try recursivelyRead(rules: evalRules())
  }
}

fileprivate func evalRule(name: Parser.NameType, indent: Parser.IndentType, type: Parser.TypeType, patterns: Parser.PatternsType, dedent: Parser.DedentType) -> Parser.RuleType {
  return Rule(name: name, type: type, patterns: patterns)
}

extension Parser {
  public typealias RuleType = Rule
  private func recursivelyRead(rule: RuleType) throws -> RuleType? {
    return rule
  }
  public func readRule() throws -> RuleType? {
    if let name = try readName() {
      if matches(string: "\n") {
        if let indent = try readIndent() {
          if let type = try readType() {
            if let patterns = try readPatterns() {
              if let dedent = try readDedent() {
                return try recursivelyRead(rule: evalRule(name: name, indent: indent, type: type, patterns: patterns, dedent: dedent))
              }
              try throwError(message:"error parsing rule. expect dedent")
            }
            try throwError(message:"error parsing rule. expect patterns")
          }
          try throwError(message:"error parsing rule. expect type")
        }
        try throwError(message:"error parsing rule. expect indent")
      }
      try throwError(message:"error parsing rule. expect \"\n\"")
    }
    return nil
  }
}

fileprivate func evalType(indent: Parser.IndentType, line: Parser.LineType, dedent: Parser.DedentType) -> Parser.TypeType {
  return line
}

extension Parser {
  public typealias TypeType = String
  private func recursivelyRead(type: TypeType) throws -> TypeType? {
    return type
  }
  public func readType() throws -> TypeType? {
    if matches(string: "type\n") {
      if let indent = try readIndent() {
        if let line = try readLine() {
          if let dedent = try readDedent() {
            return try recursivelyRead(type: evalType(indent: indent, line: line, dedent: dedent))
          }
          try throwError(message:"error parsing type. expect dedent")
        }
        try throwError(message:"error parsing type. expect line")
      }
      try throwError(message:"error parsing type. expect indent")
    }
    return nil
  }
}

fileprivate func evalPatterns(pattern: Parser.PatternType, patterns: Parser.PatternsType) -> Parser.PatternsType {
  return [pattern] + patterns
}

fileprivate func evalPatterns() -> Parser.PatternsType {
  return []
}

extension Parser {
  public typealias PatternsType = [Pattern]
  private func recursivelyRead(patterns: PatternsType) throws -> PatternsType? {
    return patterns
  }
  public func readPatterns() throws -> PatternsType? {
    if let pattern = try readPattern() {
      if let patterns = try readPatterns() {
        return try recursivelyRead(patterns: evalPatterns(pattern: pattern, patterns: patterns))
      }
      try throwError(message:"error parsing patterns. expect patterns")
    }
    return try recursivelyRead(patterns: evalPatterns())
  }
}

fileprivate func evalPattern(cws: Parser.CwsType, terms: Parser.TermsType, multiLineString: Parser.MultiLineStringType) -> Parser.PatternType {
  return Pattern(terms: terms, evaluator: multiLineString)
}

extension Parser {
  public typealias PatternType = Pattern
  private func recursivelyRead(pattern: PatternType) throws -> PatternType? {
    return pattern
  }
  public func readPattern() throws -> PatternType? {
    if matches(string: "::=") {
      if let cws = try readCws() {
        if let terms = try readTerms() {
          if matches(string: "\n") {
            if let multiLineString = try readMultiLineString() {
              return try recursivelyRead(pattern: evalPattern(cws: cws, terms: terms, multiLineString: multiLineString))
            }
            try throwError(message:"error parsing pattern. expect multiLineString")
          }
          try throwError(message:"error parsing pattern. expect \"\n\"")
        }
        try throwError(message:"error parsing pattern. expect terms")
      }
      try throwError(message:"error parsing pattern. expect cws")
    }
    return nil
  }
}

fileprivate func evalTerms(term: Parser.TermType, cws: Parser.CwsType, terms: Parser.TermsType) -> Parser.TermsType {
  return [term] + terms
}

fileprivate func evalTerms() -> Parser.TermsType {
  return []
}

extension Parser {
  public typealias TermsType = [Term]
  private func recursivelyRead(terms: TermsType) throws -> TermsType? {
    return terms
  }
  public func readTerms() throws -> TermsType? {
    if let term = try readTerm() {
      if let cws = try readCws() {
        if let terms = try readTerms() {
          return try recursivelyRead(terms: evalTerms(term: term, cws: cws, terms: terms))
        }
        try throwError(message:"error parsing terms. expect terms")
      }
      try throwError(message:"error parsing terms. expect cws")
    }
    return try recursivelyRead(terms: evalTerms())
  }
}

fileprivate func evalTerm(name: Parser.NameType) -> Parser.TermType {
  return .named(name)
}

fileprivate func evalTerm(quotedString: Parser.QuotedStringType) -> Parser.TermType {
  return .quoted(quotedString)
}

extension Parser {
  public typealias TermType = Term
  private func recursivelyRead(term: TermType) throws -> TermType? {
    return term
  }
  public func readTerm() throws -> TermType? {
    if let name = try readName() {
      return try recursivelyRead(term: evalTerm(name: name))
    }
    if let quotedString = try readQuotedString() {
      return try recursivelyRead(term: evalTerm(quotedString: quotedString))
    }
    return nil
  }
}

fileprivate func evalName(letter: Parser.LetterType, letterDigits: Parser.LetterDigitsType) -> Parser.NameType {
  return String(letter) + letterDigits

}

extension Parser {
  public typealias NameType = String
  private func recursivelyRead(name: NameType) throws -> NameType? {
    return name
  }
  public func readName() throws -> NameType? {
    if let letter = try readLetter() {
      if let letterDigits = try readLetterDigits() {
        return try recursivelyRead(name: evalName(letter: letter, letterDigits: letterDigits))
      }
      try throwError(message:"error parsing name. expect letterDigits")
    }
    return nil
  }
}
