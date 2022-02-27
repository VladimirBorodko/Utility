import Foundation
import Yams
import Facility
class Configurator {
  let yaml: Any
  init(config: String) throws {
    self.yaml = try load(yaml: config).or(NSNull())
  }
  func makeFileRules() throws -> [FileRule] {
    try Interpreter(tree: .init(any: yaml))
      .map["FileRules"]
      .or { throw Thrown("FileRules not present") }
      .decode([FileRule.Yaml].self)
      .map(FileRule.init(yaml:))
  }
}
