import Foundation
import Facility
public struct ReadFile: Query {
  public var file: String
  public init(file: String) {
    self.file = file
  }
  public typealias Reply = String
}
