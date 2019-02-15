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
    let readCall: String = isRecursive || term == nil ? "" : "\(indent)\(term?.buildReadCall(takenTermNames: &takenTermNames) ?? "")\n"

    let childHandlers: String = ( children.map{"\(indent)  do {\n\($0.buildString(ruleName: ruleName, indent: "\(indent)  ", takenTermNames: takenTermNames))\(indent)  } catch let error as ParserError where error.thrower !== nil && error.thrower !== thrower {}"} + [""]).joined(separator: "\n")

    let evaluatorCall: String
    if children.reduce(false, {$0 || !($1.term?.isConditional ?? true)}) {
      evaluatorCall = ""
    } else if let pattern = pattern {
      evaluatorCall = "\(indent)  \(pattern.buildEvaluatorCall(ruleName: ruleName))"
    } else if isRecursive {
      evaluatorCall = "\(indent)  return \(ruleName)\n"
    } else {
      evaluatorCall = "\(indent)  throw thrower.createError(message:\"error parsing \(ruleName). expect \(children.compactMap{$0.term?.getTypeName()}.joined(separator: ", "))\")\n"
    }

    return "\(readCall)\(childHandlers)\(evaluatorCall)"
  }

  var throwerDeclaration: String {
    for child in children {
      if child.throwerDeclaration != "" {
        return child.throwerDeclaration
      }
    }

    if children.reduce(false, {$0 || !($1.term?.isConditional ?? true)}) {
      return ""
    } else if pattern != nil {
      return ""
    } else if isRecursive && children.count == 0 {
      return ""
    } else {
      return "  let thrower = createThrower()\n"
    }
  }

  init(term: Term?, pattern: Pattern? = nil) {
    self.term = term
    self.pattern = pattern
  }
}
