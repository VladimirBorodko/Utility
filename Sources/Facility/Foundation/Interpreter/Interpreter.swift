import Foundation
public struct Interpreter: Decoder {
  public var tree: Tree
  public var dialect: Dialect
  public var userInfo: UserInfo
  public var codingPath: [CodingKey]
  public init(
    tree: Tree,
    dialect: Dialect = .json,
    userInfo: UserInfo = [:],
    codingPath: [CodingKey] = []
  ) {
    self.tree = tree
    self.dialect = dialect
    self.userInfo = userInfo
    self.codingPath = codingPath
  }
  public subscript<T>(type: T.Type = T.self) -> T? where T: Decodable {
    try? decode(type)
  }
  public var map: [AnyHashable: Interpreter] {
    (try? tree.map().mapValues(make(tree:))) ?? [:]
  }
  public var list: [Interpreter] {
    (try? tree.list().map(make(tree:))) ?? []
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
  internal func make(tree: Tree) -> Interpreter {
    .init(tree: tree, dialect: dialect, userInfo: userInfo, codingPath: [])
  }
}
