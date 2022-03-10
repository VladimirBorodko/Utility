import Foundation
extension Interpreter {
  enum Key : CodingKey {
    case int(Int)
    case string(String)
    case any(AnyHashable)
    var stringValue: String {
      switch self {
      case .string(let string): return string
      case .int(let int): return "\(int)"
      case .any(let any):
        return any.base as? String ?? .init(describing: any.base)
      }
    }
    var intValue: Int? {
      switch self {
      case .string(let string): return .init(string)
      case .int(let int): return int
      case .any(let any): return any.base as? Int ?? .init(stringValue)
      }
    }
    init?(stringValue: String) {
      self = .string(stringValue)
    }
    init?(intValue: Int) {
      self = .int(intValue)
    }
  }
}
