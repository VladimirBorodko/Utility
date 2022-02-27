import Foundation
extension Interpreter {
  enum Key : CodingKey {
    case int(Int)
    case string(String)
    var stringValue: String {
      switch self {
      case .string(let string): return string
      case .int(let int): return "\(int)"
      }
    }
    var intValue: Int? {
      guard case .int(let int) = self else { return nil }
      return int
    }
    init?(stringValue: String) {
      self = .string(stringValue)
    }
    init?(intValue: Int) {
      self = .int(intValue)
    }
  }
}
