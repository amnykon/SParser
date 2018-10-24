class TermNode {
  let term: Term?
  var pattern: Pattern? = nil
  var children: [TermNode] = []

  var isRecursive: Bool = false

  var isRoot: Bool {
    return term == nil
  }

  func buildString(ruleName: String, indent: String, takenTermNames: Set<String> = Set()) -> String {
    var takenTermNames = takenTermNames
    let condition: String = isRecursive || term == nil ? "" : indent + "if \(term?.buildConditionString(takenTermNames: &takenTermNames) ?? "") {\n"

    let childHandlers: String = (children.map{$0.buildString(ruleName: ruleName, indent: indent + "  ", takenTermNames: takenTermNames)} + [""]).joined(separator: "\n")

    let evaluatorCall: String
    if let pattern = pattern {
      evaluatorCall = "\(indent)  \(pattern.buildEvaluatorCall(ruleName: ruleName))"
    } else if isRecursive {
      evaluatorCall = "\(indent)  return \(ruleName)\n"
    } else if isRoot {
      evaluatorCall = "\(indent)  return nil\n"
    } else {
      evaluatorCall = "\(indent)  try throwError(message:\"error parsing \(ruleName). expect \(children.compactMap{$0.term?.getTypeName()}.joined(separator: ", "))\")\n"
    }

    return "\(condition)\(childHandlers)\(evaluatorCall)\(indent)}"
  }

  init(term: Term?, pattern: Pattern? = nil) {
    self.term = term
    self.pattern = pattern
  }
}
