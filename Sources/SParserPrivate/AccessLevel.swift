public enum AccessLevel {
  case `public`
  case `internal`
  case `private`

  public func toString() -> String {
    switch self {
    case .public:
     return "public "
    case .internal:
     return ""
    case .private:
     return "private "
    }
  }
}
