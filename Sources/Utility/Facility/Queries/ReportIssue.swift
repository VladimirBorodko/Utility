import Foundation
import Facility
public struct ReportIssue: Query {
  public var message: String
  public var time: Date
  public var count: Bool
  public init(message: String, time: Date, count: Bool = true) {
    self.message = message
    self.time = time
    self.count = count
  }
  public typealias Reply = Void
}
