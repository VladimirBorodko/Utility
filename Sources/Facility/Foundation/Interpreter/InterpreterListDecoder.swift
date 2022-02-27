import Foundation
extension Interpreter {
  public struct ListDecoder: UnkeyedDecodingContainer {
    public private(set) var currentIndex: Int = 0
    private let interpreter: Interpreter
    private let list: [Tree]?
    public init(interpreter: Interpreter) {
      self.interpreter = interpreter
      self.list = try? interpreter.tree.list()
    }
    public var count: Int? {
      list?.count
    }
    public var isAtEnd: Bool {
      currentIndex >= count.or(0)
    }
    public var codingPath: [CodingKey] {
      interpreter.codingPath
    }
    private var key: Key {
      .int(currentIndex)
    }
    private mutating func advanceAfter<T>(
      _ type: T.Type = T.self,
      make: Try.Of<Interpreter>.Make<T>
    ) throws -> T {
      guard let list = self.list, currentIndex < list.count else {
        throw MayDay("Out of bounds " + interpreter.path(key: key))
      }
      let result = try make(makeNested(tree: list[currentIndex]))
      currentIndex += 1
      return result
    }
    private func makeNested(tree: Tree) -> Interpreter {
      .init(
        tree: tree,
        dialect: interpreter.dialect,
        userInfo: interpreter.userInfo,
        codingPath: interpreter.codingPath + [Key.int(currentIndex)]
      )
    }
    public mutating func decodeNil() throws -> Bool {
      try advanceAfter { nested in
        nested.tree.isNil
      }
    }
    public mutating func decode(_ type: String.Type) throws -> String {
      try advanceAfter { nested in
        try nested.rethrow {
          try nested.tree.string()
        }
      }
    }
    public mutating func decode(_ type: Bool.Type) throws -> Bool {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: Double.Type) throws -> Double {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: Float.Type) throws -> Float {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: Int.Type) throws -> Int {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: Int8.Type) throws -> Int8 {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: Int16.Type) throws -> Int16 {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: Int32.Type) throws -> Int32 {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: Int64.Type) throws -> Int64 {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: UInt.Type) throws -> UInt {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
      try advanceAfter { nested in
        try nested.rethrow {
          try ?!.init(exactly: nested.tree.number())
        }
      }
    }
    public mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
      try advanceAfter { nested in
        try nested.decode(type)
      }
    }
    public mutating func nestedContainer<NestedKey>(
      keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey>
    where NestedKey : CodingKey {
      try advanceAfter { nested in
        try nested.container(keyedBy: type)
      }
    }
    public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
      try advanceAfter { nested in
        try nested.unkeyedContainer()
      }
    }
    public mutating func superDecoder() throws -> Decoder {
      try advanceAfter { nested in
        nested
      }
    }
  }
}
