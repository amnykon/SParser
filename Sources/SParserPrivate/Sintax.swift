public struct Syntax {
  public let imports: [String]
  public let rules: [Rule]
  
  public func buildString() -> String {
    return """
      \(imports.map{"import " + $0 + "\n"}.joined())

      extension Parser {
      \(rules.map{$0.buildString()}.joined(separator: "\n"))
      }

      """
  }
}

