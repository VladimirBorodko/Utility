import Foundation
extension Interpreter {
  public enum Tree: Decodable {
    case value(Value)
    case list([Tree])
    case map([AnyHashable: Tree])
    public init(any: Any) throws {
      if any is NSNull {
        self = .value(.null)
      } else if let value = any as? NSNumber {
        self = .value(.number(value))
      } else if let value = any as? String {
        self = .value(.string(value))
      } else if let value = any as? [Any] {
        try self = .list(value.map(Self.init(any:)))
      } else if let value = any as? [AnyHashable: Any] {
        try self = .map(value.mapValues(Self.init(any:)))
      } else {
        throw Thrown("Invalid object hierarchy")
      }
    }
    public init(from decoder: Decoder) throws {
      if let decoder = decoder as? Interpreter {
        self = decoder.tree
        return
      }
      let container = try decoder.singleValueContainer()
      if container.decodeNil() {
        self = .value(.null)
      } else if let value = try? container.decode(Bool.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(Int64.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(Int32.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(Int16.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(Int8.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(UInt64.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(UInt32.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(UInt16.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(UInt8.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(Double.self) {
        self = .value(.number(.init(value: value)))
      } else if let value = try? container.decode(Float.self) {
        self = .value(.number(.init(value: value)))
      } else if let string = try? container.decode(String.self) {
          self = .value(.string(string))
      } else if let list = try? container.decode([Self].self) {
          self = .list(list)
      } else if let map = try? container.decode([String: Self].self) {
          self = .map(map)
      } else if let map = try? container.decode([Int: Self].self) {
          self = .map(map)
      } else { throw Thrown("Value can not be decoded") }
    }
    public enum Value {
      case null
      case number(NSNumber)
      case string(String)
    }
    public var isNil: Bool {
      guard case .value(.null) = self else {
        return false
      }
      return true
    }
    public func string() throws -> String {
      guard case .value(.string(let string)) = self else {
        throw Thrown()
      }
      return string
    }
    public func number() throws -> NSNumber {
      guard case .value(.number(let number)) = self else {
        throw Thrown()
      }
      return number
    }
    public func list() throws -> [Tree] {
      guard case .list(let list) = self else {
        throw Thrown()
      }
      return list
    }
    public func map() throws -> [AnyHashable: Tree] {
      guard case .map(let map) = self else {
        throw Thrown()
      }
      return map
    }
  }
}
