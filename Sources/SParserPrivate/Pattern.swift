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
      case .type:
        return "\(term.getName(takenTermNames: &usedTermNames)): \(term.getTypeName())"
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
    var usedTermNodeNames: Set<String> = Set()
    let termsString = terms.compactMap{
      (term)->String? in
      switch term {
      case .quoted:
        return nil
      case .type:
        return "\(term.getName(takenTermNames: &usedTermNames)): \(term.getNodeName(takenTermNames: &usedTermNodeNames))"
      case .indent:
        return nil
      case .dedent:
        return nil
      }
    }.joined(separator: ", ")
    return "return try recursivelyRead(\(ruleName): eval\(id)\(ruleName.capitalizedFirstLetter())(\(termsString)))\n"
  }
}

