class TermNode {
  let term: Term?
  var pattern: Pattern? = nil
  var children: [TermNode] = []

  var isRoot: Bool {
    return term == nil
  }

  func buildString(ruleName: String, indent: String) -> String {
    let evaluatorCall: String = {
      guard let pattern = pattern else {
        if isRoot {
          return indent + "  return nil\n"
        }
        return ""
      }
      return indent + "  " + pattern.buildEvaluatorCall(ruleName: ruleName)
    }()
    return [
      term != nil ? indent + "if \(term?.buildConditionString() ?? "") {\n" : "",
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
