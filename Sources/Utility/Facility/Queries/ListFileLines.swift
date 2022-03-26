import Foundation
import Facility
public struct ListFileLines: Query {
  public var file: String
  public init(file: String) {
    self.file = file
  }
  public typealias Reply = AnyIterator<String>
}
