import Foundation
import Yams
import Facility
import FacilityQueries
public enum YamlParser {
  public static func parseYaml(query: ParseYaml) throws -> Interpreter.Tree {
    let any = try load(yaml: query.content).or(NSNull())
    return try .init(any: any)
  }
}
