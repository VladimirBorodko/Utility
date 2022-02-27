import Foundation
import Facility
class IssueTracker {
  private var issueCount: UInt = 0
  private let putLine: Act.Send<String>
  let formatter: DateFormatter
  init(putLine: @escaping Act.Send<String>) {
    self.putLine = putLine
    self.formatter = .init()
    formatter.dateFormat = "HH:mm:ss"
  }
  func format<T: StringProtocol>(message: T) -> String {
    "[\(formatter.string(from: .init()))]: \(message)"
  }
  func report(message: String) {
    issueCount += 1
    message
      .split(separator: "\n")
      .filter { !$0.isEmpty }
      .map(format(message:))
      .forEach(putLine)
  }
  func finish() throws {
    guard issueCount > 0 else { return }
    defer { issueCount = 0 }
    throw Thrown("Found \(issueCount) issues")
  }
}