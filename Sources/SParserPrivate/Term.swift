enum Term {
  case type(name: String?, type:String)
  case quoted(String)
  case indent
  case dedent

  func getTypeName() -> String {
    switch self {
      case let .type(_, type):
        return "\(type.capitalizedFirstLetter())Type"
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
      case let .type(name, _):
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
       case let .type(_, type):
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

  func buildConditionString(takenTermNames: inout Set<String>) -> String {
    switch self {
      case let .type(_, type):
        return "let \(getNodeName(takenTermNames: &takenTermNames)) = try read\(type.capitalizedFirstLetter())()"
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
    case (let .type(_, lhsType), let .type(_, rhsType)):
        return lhsType == rhsType
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

