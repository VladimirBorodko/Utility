import Foundation
import Facility
public struct ParseYaml: Query {
  public var content: String
  public init(content: String) {
    self.content = content
  }
  public typealias Reply = Interpreter.Tree
}
