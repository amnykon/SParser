struct Rule {
  let name: String
  let accessLevel: AccessLevel
  let type: String
  let patterns: [Pattern]

  func buildString() -> String {
    /* build TermNode */
    let rootTermNode = TermNode(term: nil)
    for pattern in patterns {
      var termNode = rootTermNode
      for term in pattern.terms {
        var hasFoundChildTermNode = false
        for childTermNode in termNode.children {
          if childTermNode.term == term {
             termNode = childTermNode
             hasFoundChildTermNode = true
             break;
          }
        }
        if !hasFoundChildTermNode {
          let newChildTermNode = TermNode(term: term)
          termNode.children.append(newChildTermNode)
          termNode = newChildTermNode
        }
      }
      termNode.pattern = pattern
    }
    var recursiveTermNode = TermNode(term: nil)
    if let recursiveTermNodeIndex = rootTermNode.children.index(where: {$0.term == .type(name: nil, type: name, modifier: .one)}) {
      recursiveTermNode = rootTermNode.children[recursiveTermNodeIndex]
      rootTermNode.children.remove(at: recursiveTermNodeIndex)
    }
    recursiveTermNode.isRecursive = true

    return """
        \(accessLevel.toString())typealias \(name.capitalizedFirstLetter())Type = \(type)
        \(accessLevel.toString())func read\(name.capitalizedFirstLetter())() throws -> \(name.capitalizedFirstLetter())Type {
        \(rootTermNode.throwerDeclaration)\(rootTermNode.buildString(ruleName: name, indent: "  "))  }
        private func recursivelyRead(\(name): \(name.capitalizedFirstLetter())Type) throws -> \(name.capitalizedFirstLetter())Type {
        \(recursiveTermNode.throwerDeclaration)\(recursiveTermNode.buildString(ruleName: name, indent: "  "))  }
      \(patterns.map{$0.buildEvaluatorFunction(ruleName: name)}.joined())
      """
  }
}

