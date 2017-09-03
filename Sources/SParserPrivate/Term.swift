public enum Term {
  case named(String)
  case quoted(String)

  public func getName() -> String {
    switch self {
      case let .named(name):
        return name
      case let .quoted(quoted):
        return "\\\"\(quoted)\\\""
    }
  }

  public func buildConditionString() -> String {
    switch self {
      case let .named(name):
        return "let \(name) = try read\(name.capitalizedFirstLetter())()"
      case let .quoted(quoted):
        return "matches(string: \"\(quoted)\")"
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
    default:
        return false
    }
  }
}

