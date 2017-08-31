import Foundation

extension String {
  func capitalizedFirstLetter() -> String {
    let first = String(characters.prefix(1)).capitalized
    let other = String(characters.dropFirst())
    return first + other
  }
  func indent(_ string: String) -> String{
    return string + components(separatedBy: "\n").joined(separator: "\n" + string)
  }
}

