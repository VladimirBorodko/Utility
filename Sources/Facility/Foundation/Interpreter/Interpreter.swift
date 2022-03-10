import Foundation
public struct Interpreter: Decoder {
  public var tree: Tree
  public var dialect: Dialect
  public var userInfo: UserInfo
  public var codingPath: [CodingKey] = []
  public init(
    tree: Tree,
    dialect: Dialect = .json,
    userInfo: UserInfo = [:]
  ) {
    self.tree = tree
    self.dialect = dialect
    self.userInfo = userInfo
  }
  public subscript<T>(type: T.Type = T.self) -> T? where T: Decodable {
    try? decode(type)
  }
  public var map: [AnyHashable: Interpreter] {
    guard let map = try? tree.map() else { return [:] }
    return map.reduce(into: [:]) { map, pair in
      map[pair.key] = make(tree: pair.value, key: Key.any(pair.key) )
    }
  }
  public var list: [Interpreter] {
    guard let list = try? tree.list() else { return [] }
    return list.enumerated().map { index, tree in
      make(tree: tree, key: Key.int(index))
    }
  }
  public var string: String? {
    try? tree.string()
  }
  public var number: NSNumber? {
    try? tree.number()
  }
  public func singleValueContainer() throws -> SingleValueDecodingContainer {
    ValueDecoder(interpreter: self)
  }
  public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    ListDecoder(interpreter: self)
  }
  public func container<Key>(
    keyedBy type: Key.Type
  ) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
    .init(MapDecoder(interpreter: self))
  }
  public typealias UserInfo = [CodingUserInfoKey : Any]
  public func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
    try dialect[type].or(type.init(from:))(self)
  }
  internal func make(tree: Tree, key: CodingKey? = nil) -> Interpreter {
    var result = self
    result.tree = tree
    result.codingPath += key.makeArray()
    return result
  }
}
