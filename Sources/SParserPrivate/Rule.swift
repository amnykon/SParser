public struct Rule {
  public let name: String
  public let type: String
  public let patterns: [Pattern]
  
  public func buildString() -> String {
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
    if let recursiveTermNodeIndex = rootTermNode.children.index(where: {$0.term == .named(name)}) {
      recursiveTermNode = rootTermNode.children[recursiveTermNodeIndex]
      rootTermNode.children.remove(at: recursiveTermNodeIndex)
    }
    recursiveTermNode.isRecursive = true

    return [
      patterns.map{$0.buildEvaluatorString(ruleName: name)}.joined(separator: "\n"),
      "\n",
      "extension Parser {\n",
      "  public typealias \(name.capitalizedFirstLetter())Type = \(type)\n",
      "  private func recursivelyRead(\(name): \(name.capitalizedFirstLetter())Type) throws -> \(name.capitalizedFirstLetter())Type? {\n",
      recursiveTermNode.buildString(ruleName: name, indent: "  "),
      "  public func read\(name.capitalizedFirstLetter())() throws -> \(name.capitalizedFirstLetter())Type? {\n",
      rootTermNode.buildString(ruleName: name, indent: "  "),
      "}\n",
    ].joined()
  }
}

