import Foundation
extension Interpreter {
  public struct ValueDecoder: SingleValueDecodingContainer {
    let interpreter: Interpreter
    public init(interpreter: Interpreter) {
      self.interpreter = interpreter
    }
    public var codingPath: [CodingKey] {
      interpreter.codingPath
    }
    public func decodeNil() -> Bool {
      interpreter.tree.isNil
    }
    public func decode(_ type: String.Type) throws -> String {
      try interpreter.rethrow {
        try interpreter.tree.string()
      }
    }
    public func decode(_ type: Bool.Type) throws -> Bool {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: Double.Type) throws -> Double {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: Float.Type) throws -> Float {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: Int.Type) throws -> Int {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: Int8.Type) throws -> Int8 {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: Int16.Type) throws -> Int16 {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: Int32.Type) throws -> Int32 {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: Int64.Type) throws -> Int64 {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: UInt.Type) throws -> UInt {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
      try interpreter.rethrow {
        try ?!.init(exactly: interpreter.tree.number())
      }
    }
    public func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
      try interpreter.dialect[type].or(type.init(from:))(interpreter)
    }
  }
}
