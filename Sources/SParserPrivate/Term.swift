enum Term {
  case type(name: String?, type: String, modifier: TermModifier)
  case quoted(String)
  case indent
  case dedent

  func getTypeName() -> String {
    switch self {
      case let .type(_, type, modifier):
        let singleName = "\(type.capitalizedFirstLetter())Type"
        switch modifier {
        case .oneOrMore, .zeroOrMore:
          return "[\(singleName)]"
        case .one:
          return singleName
        case .optional:
          return "\(singleName)?"
        }
      case let .quoted(quoted):
        return "\\\"\(quoted)\\\""
      case .indent:
        return ""
      case .dedent:
        return ""
    }
  }

  func getName(takenTermNames: inout Set<String>) -> String {
     switch self {
      case let .type(name, _, _):
          if let name = name {
           return name
         }
         return getNodeName(takenTermNames: &takenTermNames)
      case .quoted:
        return ""
      case .indent:
        return ""
      case .dedent:
        return ""
    }
  }

  func getNodeName(takenTermNames: inout Set<String>) -> String {
     switch self {
       case let .type(_, type, _):
         var name = type
         var i = 1
         while takenTermNames.contains(name) {
           name = "\(type)\(i)"
           i += 1
         }
         takenTermNames.insert(name)
         return name
      case .quoted:
        return ""
      case .indent:
        return ""
      case .dedent:
        return ""
    }
  }

  var isConditional: Bool {
    switch self {
    case let .type(_, _, modifier):
      switch modifier {
      case .oneOrMore, .one:
        return true
      case .optional, .zeroOrMore:
        return true
      }
    case .quoted, .indent, .dedent:
      return true
    }
  }

  func buildReadCall(takenTermNames: inout Set<String>) -> String {
    switch self {
      case let .type(_, type, modifier):
        switch modifier {
        case .optional:
          return "let \(getNodeName(takenTermNames: &takenTermNames)) = try? read\(type.capitalizedFirstLetter())()"
          return "let \(getNodeName(takenTermNames: &takenTermNames)) = try readOptional({try read\(type.capitalizedFirstLetter())()})"
        case .oneOrMore:
          return "let \(getNodeName(takenTermNames: &takenTermNames)) = try readOneOrMore({try read\(type.capitalizedFirstLetter())()})"
        case .zeroOrMore:
          return "let \(getNodeName(takenTermNames: &takenTermNames)) = try readZeroOrMore({try read\(type.capitalizedFirstLetter())()})"
        case .one:
          return "let \(getNodeName(takenTermNames: &takenTermNames)) = try read\(type.capitalizedFirstLetter())()"
        }
      case let .quoted(quoted):
        return "try read(string: \"\(quoted)\")"
      case .indent:
        return "try readIndent()"
      case .dedent:
        return "try readDedent()"
    }
  }
}

extension Term: Equatable {
  public static func ==(lhs: Term, rhs: Term) -> Bool {
    switch (lhs, rhs) {
    case (let .type(_, lhsType, lhsModifier), let .type(_, rhsType, rhsModifier)):
        return lhsType == rhsType && lhsModifier == rhsModifier
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

