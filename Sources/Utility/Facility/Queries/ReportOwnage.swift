import Foundation
import Facility
public struct ReportOwnage: Query {
  public var owner: String
  public init(owner: String) {
    self.owner = owner
  }
  public typealias Reply = Void
}
