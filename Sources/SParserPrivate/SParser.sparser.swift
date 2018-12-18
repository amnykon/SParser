import Foundation
import SParserLibs

extension Parser {
  public typealias SyntaxType = Syntax
  public func readSyntax() throws -> SyntaxType {
    let thrower = createThrower()
    do {
    let importRule = try? readImportRule()
      do {
      let rule = try readZeroOrMore({try readRule()})
        return try recursivelyRead(syntax: eval0Syntax(importRule: importRule, rules: rule))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing syntax. expect [RuleType]")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing syntax. expect ImportRuleType?")
  }
  private func recursivelyRead(syntax: SyntaxType) throws -> SyntaxType {
    let thrower = createThrower()
    return syntax
  }
  private func eval0Syntax(importRule: ImportRuleType?, rules: [RuleType]) -> SyntaxType {
    return Syntax(imports: importRule ?? [], rules: rules)
  }

  private typealias ImportRuleType = [String]
  private func readImportRule() throws -> ImportRuleType {
    let thrower = createThrower()
    do {
    try read(string: "imports\n")
      do {
      try readIndent()
        do {
        let line = try readOneOrMore({try readLine()})
          do {
          try readDedent()
            return try recursivelyRead(importRule: eval0ImportRule(imports: line))
          } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
          throw thrower.createError(message:"error parsing importRule. expect ")
        } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
        throw thrower.createError(message:"error parsing importRule. expect [LineType]")
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing importRule. expect ")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing importRule. expect \"imports\n\"")
  }
  private func recursivelyRead(importRule: ImportRuleType) throws -> ImportRuleType {
    let thrower = createThrower()
    return importRule
  }
  private func eval0ImportRule(imports: [LineType]) -> ImportRuleType {
    return imports
  }

  private typealias RuleType = Rule
  private func readRule() throws -> RuleType {
    let thrower = createThrower()
    do {
    let name = try readName()
      do {
      try read(string: "\n")
        do {
        try readIndent()
          do {
          try read(string: "type\n")
            do {
            try readIndent()
              do {
              let accessLevel = try? readAccessLevel()
                do {
                let line = try readLine()
                  do {
                  try readDedent()
                    do {
                    let patterns = try readPatterns()
                      do {
                      try readDedent()
                        return try recursivelyRead(rule: eval0Rule(name: name, accessLevel: accessLevel, type: line, patterns: patterns))
                      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
                      throw thrower.createError(message:"error parsing rule. expect ")
                    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
                    throw thrower.createError(message:"error parsing rule. expect PatternsType")
                  } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
                  throw thrower.createError(message:"error parsing rule. expect ")
                } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
                throw thrower.createError(message:"error parsing rule. expect LineType")
              } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
              throw thrower.createError(message:"error parsing rule. expect AccessLevelType?")
            } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
            throw thrower.createError(message:"error parsing rule. expect ")
          } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
          throw thrower.createError(message:"error parsing rule. expect \"type\n\"")
        } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
        throw thrower.createError(message:"error parsing rule. expect ")
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing rule. expect \"\n\"")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing rule. expect NameType")
  }
  private func recursivelyRead(rule: RuleType) throws -> RuleType {
    let thrower = createThrower()
    return rule
  }
  private func eval0Rule(name: NameType, accessLevel: AccessLevelType?, type: LineType, patterns: PatternsType) -> RuleType {
    return Rule(name: name, accessLevel: accessLevel ?? .internal, type: type, patterns: patterns)
  }

  private typealias AccessLevelType = AccessLevel
  private func readAccessLevel() throws -> AccessLevelType {
    let thrower = createThrower()
    do {
    try read(string: "public ")
      return try recursivelyRead(accessLevel: eval0AccessLevel())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
    try read(string: "internal ")
      return try recursivelyRead(accessLevel: eval1AccessLevel())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
    try read(string: "private ")
      return try recursivelyRead(accessLevel: eval2AccessLevel())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing accessLevel. expect \"public \", \"internal \", \"private \"")
  }
  private func recursivelyRead(accessLevel: AccessLevelType) throws -> AccessLevelType {
    let thrower = createThrower()
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
  private func readPatterns() throws -> PatternsType {
    let thrower = createThrower()
    return try recursivelyRead(patterns: eval1Patterns())
  }
  private func recursivelyRead(patterns: PatternsType) throws -> PatternsType {
    let thrower = createThrower()
    do {
    let pattern = try readPattern()
      return try recursivelyRead(patterns: eval0Patterns(patterns: patterns, pattern: pattern))
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    return patterns
  }
  private func eval0Patterns(patterns: PatternsType, pattern: PatternType) -> PatternsType {
    return patterns + [Pattern(terms: pattern.terms, evaluator: pattern.evaluator, id: patterns.count)]
  }
  private func eval1Patterns() -> PatternsType {
    return []
  }

  private typealias PatternType = Pattern
  private func readPattern() throws -> PatternType {
    let thrower = createThrower()
    do {
    try read(string: "::=")
      do {
      let cws = try readCws()
        do {
        let term = try readZeroOrMore({try readTerm()})
          do {
          try read(string: "\n")
            do {
            let multiLineString = try readMultiLineString()
              return try recursivelyRead(pattern: eval0Pattern(cws: cws, terms: term, multiLineString: multiLineString))
            } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
            throw thrower.createError(message:"error parsing pattern. expect MultiLineStringType")
          } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
          throw thrower.createError(message:"error parsing pattern. expect \"\n\"")
        } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
        throw thrower.createError(message:"error parsing pattern. expect [TermType]")
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing pattern. expect CwsType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing pattern. expect \"::=\"")
  }
  private func recursivelyRead(pattern: PatternType) throws -> PatternType {
    let thrower = createThrower()
    return pattern
  }
  private func eval0Pattern(cws: CwsType, terms: [TermType], multiLineString: MultiLineStringType) -> PatternType {
    return Pattern(terms: terms, evaluator: multiLineString, id: 0)
  }

  private typealias TermType = Term
  private func readTerm() throws -> TermType {
    let thrower = createThrower()
    do {
    try read(string: "indent")
      do {
      let cws = try readCws()
        return try recursivelyRead(term: eval0Term(cws: cws))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing term. expect CwsType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
    try read(string: "dedent")
      do {
      let cws = try readCws()
        return try recursivelyRead(term: eval1Term(cws: cws))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing term. expect CwsType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
    let name = try readName()
      do {
      try read(string: ":")
        do {
        let name1 = try readName()
          do {
          let termModifier = try? readTermModifier()
            do {
            let cws = try readCws()
              return try recursivelyRead(term: eval2Term(name: name, type: name1, termModifier: termModifier, cws: cws))
            } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
            throw thrower.createError(message:"error parsing term. expect CwsType")
          } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
          throw thrower.createError(message:"error parsing term. expect TermModifierType?")
        } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
        throw thrower.createError(message:"error parsing term. expect NameType")
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      do {
      let termModifier = try? readTermModifier()
        do {
        let cws = try readCws()
          return try recursivelyRead(term: eval3Term(type: name, termModifier: termModifier, cws: cws))
        } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
        throw thrower.createError(message:"error parsing term. expect CwsType")
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing term. expect \":\", TermModifierType?")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
    let quotedString = try readQuotedString()
      do {
      let cws = try readCws()
        return try recursivelyRead(term: eval4Term(quotedString: quotedString, cws: cws))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing term. expect CwsType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing term. expect \"indent\", \"dedent\", NameType, QuotedStringType")
  }
  private func recursivelyRead(term: TermType) throws -> TermType {
    let thrower = createThrower()
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
  private func readTermModifier() throws -> TermModifierType {
    let thrower = createThrower()
    do {
    try read(string: "?")
      return try recursivelyRead(termModifier: eval0TermModifier())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
    try read(string: "+")
      return try recursivelyRead(termModifier: eval1TermModifier())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    do {
    try read(string: "*")
      return try recursivelyRead(termModifier: eval2TermModifier())
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing termModifier. expect \"?\", \"+\", \"*\"")
  }
  private func recursivelyRead(termModifier: TermModifierType) throws -> TermModifierType {
    let thrower = createThrower()
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
  private func readName() throws -> NameType {
    let thrower = createThrower()
    do {
    let letter = try readLetter()
      do {
      let letterDigits = try readLetterDigits()
        return try recursivelyRead(name: eval0Name(letter: letter, letterDigits: letterDigits))
      } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
      throw thrower.createError(message:"error parsing name. expect LetterDigitsType")
    } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}
    throw thrower.createError(message:"error parsing name. expect LetterType")
  }
  private func recursivelyRead(name: NameType) throws -> NameType {
    let thrower = createThrower()
    return name
  }
  private func eval0Name(letter: LetterType, letterDigits: LetterDigitsType) -> NameType {
    return String(letter) + letterDigits

  }
}
