import Foundation
import Facility
public struct FileRule {
  public var rule: String
  public var fileCriteria: Criteria
  public var lineCriteria: Criteria
  private init(yaml: Yaml) throws {
    self.rule = yaml.rule
    self.fileCriteria = try .init(includes: yaml.includeFile, excludes: yaml.excludeFile)
    self.lineCriteria = try .init(includes: yaml.includeLine, excludes: yaml.excludeLine)
    if fileCriteria.isEmpty && lineCriteria.isEmpty {
      throw Thrown("Empty rule \(yaml.rule)")
    }
  }
  public static func makeArray(tree: Interpreter.Tree) throws -> [Self] {
    try Interpreter(tree: tree)
      .map["FileRules"]
      .or { throw Thrown("FileRules not present") }
      .decode([FileRule.Yaml].self)
      .map(FileRule.init(yaml:))
  }
  private struct Yaml: Decodable {
    var rule: String
    var includeFile: [String]?
    var excludeFile: [String]?
    var includeLine: [String]?
    var excludeLine: [String]?
  }
}
