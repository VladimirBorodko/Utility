import Foundation
import Facility
import FacilityQueries
public final class IssueTracker {
  private var issueCount: UInt = 0
  private let wire: Wire
  public init(wire: Wire) { self.wire = wire }
  public func reportIssue(query: ReportIssue) throws -> ReportIssue.Reply {
    query.count.then { issueCount += 1 }
    try query.message
      .split(separator: "\n")
      .compactMap { line in
        line.isEmpty.else("[\(wire.formatter.string(from: query.time))]: \(line)")
      }
      .forEach(wire.logLine)
  }
  public func ensureNoIssues() throws {
    guard issueCount > 0 else { return }
    defer { issueCount = 0 }
    throw Thrown("Found \(issueCount) issues")
  }
  public struct Wire {
    public var logLine: Try.Of<String>.Go
    public var formatter: DateFormatter
    public init(
      logLine: @escaping Try.Of<String>.Go,
      formatter: DateFormatter? = nil
    ) {
      self.logLine = logLine
      self.formatter = formatter.or {
        let result = DateFormatter()
        result.dateFormat = "HH:mm:ss"
        return result
      }
    }
  }
}
