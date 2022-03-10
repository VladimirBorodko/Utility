import Foundation
import Facility
struct FileRule {
  var rule: String
  var fileCriteria: Criteria
  var lineCriteria: Criteria
  private init(yaml: Yaml) throws {
    self.rule = yaml.rule
    self.fileCriteria = try .init(includes: yaml.includeFile, excludes: yaml.excludeFile)
    self.lineCriteria = try .init(includes: yaml.includeLine, excludes: yaml.excludeLine)
    if fileCriteria.isEmpty && lineCriteria.isEmpty {
      throw Thrown("Empty rule \(yaml.rule)")
    }
  }
  static func make(tree: Interpreter.Tree) throws -> [FileRule] {
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
