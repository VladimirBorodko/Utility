import Foundation
import Facility
public struct CodeOwner {
  public var name: String
  public var ownage: Criteria
  private init(name: String, ownage: Criteria) throws {
    self.name = name
    self.ownage = ownage
    if ownage.isEmpty {
      throw Thrown("Empty group \(name)")
    }
  }
  public static func makeArray(tree: Interpreter.Tree) throws -> [Self] {
    try Interpreter(tree: tree)
      .map["CodeOwners"]
      .or { throw Thrown("CodeOwners not present") }
      .map
      .map(self.make(key:interpreter:))
  }
  private static func make(key: AnyHashable, interpreter: Interpreter) throws -> CodeOwner {
    guard let key = key.base as? String else { throw Thrown("Bad group name \(key.base)") }
    if let includes = try? interpreter.decode([String].self) {
      return try .init(name: key, ownage: .init(includes: includes))
    }
    if let yaml = try? interpreter.decode(Yaml.self) {
      let includes = yaml.include.or([])
      let excludes = yaml.exclude.or([])
      return try .init(name: key, ownage: .init(includes: includes, excludes: excludes))
    }
    throw Thrown("Bad group format \(key)")
  }
  private struct Yaml: Decodable {
    var include: [String]?
    var exclude: [String]?
  }
}
