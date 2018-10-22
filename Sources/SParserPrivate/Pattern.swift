import Foundation

public struct Pattern {
  public let terms: [Term]
  public let evaluator: String
  public let id: Int

  func buildEvaluatorFunction(ruleName: String) -> String {
    var usedTermNames: Set<String> = Set()
    let termsString = terms.compactMap{
      (term)->String? in
      switch term {
      case .quoted:
        return nil
      case let .named(name):
        var modifiedName = name
        var i = 1
        while usedTermNames.contains(modifiedName) {
          modifiedName = "\(name)\(i)"
          i += 1
        }
        usedTermNames.insert(modifiedName)
        return "\(modifiedName): \(name.capitalizedFirstLetter())Type"
      case .indent:
        return nil
      case .dedent:
        return nil
      }
    }.joined(separator: ", ")
    return
      "  fileprivate func eval\(id)\(ruleName.capitalizedFirstLetter())(\(termsString)) -> \(ruleName.capitalizedFirstLetter())Type {\n" +
      "    \(evaluator)\n" +
      "  }\n"
  }

  func buildEvaluatorCall(ruleName: String) -> String {
    var usedTermNames: Set<String> = Set()
    let termsString = terms.compactMap{
      (term)->String? in
      switch term {
      case .quoted:
        return nil
      case let .named(name):
        var modifiedName = name
        var i = 1
        while usedTermNames.contains(modifiedName) {
          modifiedName = "\(name)\(i)"
          i += 1
        }
        usedTermNames.insert(modifiedName)
        return "\(modifiedName): \(modifiedName)"
      case .indent:
        return nil
      case .dedent:
        return nil
      }
    }.joined(separator: ", ")
    return "return try recursivelyRead(\(ruleName): eval\(id)\(ruleName.capitalizedFirstLetter())(\(termsString)))\n"
  }
}

