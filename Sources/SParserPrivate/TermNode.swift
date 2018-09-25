class TermNode {
  let term: Term?
  var pattern: Pattern? = nil
  var children: [TermNode] = []

  var isRecursive: Bool = false

  var isRoot: Bool {
    return term == nil
  }

  func buildString(ruleName: String, indent: String) -> String {
    let evaluatorCall: String = {
      guard let pattern = pattern else {
        if isRecursive {
          return indent + "  return \(ruleName)\n"
        }
        if isRoot {
          return indent + "  return nil\n"
        }
        return indent + "  try throwError(message:\"error parsing \(ruleName). expect \(children.compactMap{$0.term?.getName()}.joined(separator: ", "))\")\n"
      }
      return indent + "  " + pattern.buildEvaluatorCall(ruleName: ruleName)
    }()
    return [
      isRecursive ? "" : term != nil ? indent + "if \(term?.buildConditionString() ?? "") {\n" : "",
      children.map{$0.buildString(ruleName: ruleName, indent: indent + "  ")}.joined(),
      evaluatorCall,
      indent + "}\n"
    ].joined()
  }

  init(term: Term?, pattern: Pattern? = nil) {
    self.term = term
    self.pattern = pattern
  }
}
