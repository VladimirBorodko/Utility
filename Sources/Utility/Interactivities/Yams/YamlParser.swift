import Foundation
import Yams
import Facility
enum YamlParser {
  static func parse(yaml: String) throws -> Interpreter.Tree {
    let any = try load(yaml: yaml).or(NSNull())
    return try .init(any: any)
  }
}
