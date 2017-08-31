import Foundation

public struct Pattern {
  public let terms: [Term]
  public let evaluator: String

  func buildEvaluatorString(ruleName: String) -> String {
    let termsString = terms.flatMap{
      (term)->String? in
      switch term {
      case .quoted:
        return nil
      case let .named(name):
        return "\(name): Parser.\(name.capitalizedFirstLetter())Type"
      }
    }.joined(separator: ", ")
    return 
      "fileprivate func eval\(ruleName.capitalizedFirstLetter())(\(termsString)) -> Parser.\(ruleName.capitalizedFirstLetter())Type {\n" +
      "  \(evaluator)\n" +
      "}\n"
  }

  func buildEvaluatorCall(ruleName: String) -> String {
    let termsString = terms.flatMap{
      (term)->String? in
      switch term {
      case .quoted:
        return nil
      case let .named(name):
        return "\(name): \(name)"
      }
    }.joined(separator: ", ")
    return "return eval\(ruleName.capitalizedFirstLetter())(\(termsString))\n"
  }
}

