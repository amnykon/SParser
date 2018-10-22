public enum Term {
  case named(String)
  case quoted(String)
  case indent
  case dedent

  public func getName() -> String {
    switch self {
      case let .named(name):
        return name
      case let .quoted(quoted):
        return "\\\"\(quoted)\\\""
      case .indent:
        return ""
      case .dedent:
        return ""
    }
  }

  public func buildConditionString(usedTermNames: inout Set<String>) -> String {
    switch self {
      case let .named(name):
        var modifiedName = name
        var i = 1
        while usedTermNames.contains(modifiedName) {
          modifiedName = "\(name)\(i)"
          i += 1
        }
        usedTermNames.insert(modifiedName)
        return "let \(modifiedName ) = try read\(name.capitalizedFirstLetter())()"
      case let .quoted(quoted):
        return "matches(string: \"\(quoted)\")"
      case .indent:
        return "readIndent()"
      case .dedent:
        return "readDedent()"
    }
  }
}

extension Term: Equatable {
  public static func ==(lhs: Term, rhs: Term) -> Bool {
    switch (lhs, rhs) {
    case (let .named(lhsName), let .named(rhsName)):
        return lhsName == rhsName
    case (let .quoted(lhsString), let .quoted(rhsString)):
        return lhsString == rhsString
    case (.indent, .indent):
        return true
    case (.dedent, .dedent):
        return true
    default:
        return false
    }
  }
}

