import Foundation
extension Interpreter {
  public struct MapDecoder<Key: CodingKey>: KeyedDecodingContainerProtocol {
    private let interpreter: Interpreter
    private let map: [AnyHashable: Tree]
    public init(interpreter: Interpreter) {
      self.interpreter = interpreter
      self.map = (try? interpreter.tree.map()).or([:])
    }
    public var codingPath: [CodingKey] {
      interpreter.codingPath
    }
    public var allKeys: [Key] {
      map.keys.compactMap { key in
        try? (key.base as? String)
          .flatMap(Key.init(stringValue:))
          .or(?!Key(intValue: ?!(key.base as? Int)))
      }
    }
    public func contains(_ key: Key) -> Bool {
      getTree(key: key) != nil
    }
    public func decodeNil(forKey key: Key) throws -> Bool {
      try interpreter.rethrow(key: key) {
        getTree(key: key).map { $0.isNil }.or(false)
      }
    }
    public func decode(_ type: String.Type, forKey key: Key) throws -> String {
      try interpreter.rethrow(key: key) {
        try ?!getTree(key: key)?.string()
      }
    }
    public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
      try interpreter.rethrow(key: key) {
        try ?!.init(exactly: ?!getTree(key: key)?.number())
      }
    }
    public func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
      try makeNested(key: key).decode(type)
    }
    public func nestedContainer<NestedKey>(
      keyedBy type: NestedKey.Type,
      forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey>
    where NestedKey : CodingKey {
      try makeNested(key: key).container(keyedBy: NestedKey.self)
    }
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
      try makeNested(key: key).unkeyedContainer()
    }
    public func superDecoder() throws -> Decoder {
      interpreter
    }
    public func superDecoder(forKey key: Key) throws -> Decoder {
      try makeNested(key: key)
    }
    private func getTree(key: Key) -> Tree? {
      key.intValue
        .flatMap { map[$0] }
        .flatMapNil { map[key.stringValue] }
    }
    private func makeNested(key: Key) throws -> Interpreter {
      let tree = try Thrown.rethrow("Not present " + interpreter.path(key: key)) {
        try ?!getTree(key: key)
      }
      return interpreter.make(tree: tree, key: key)
    }
  }
}
