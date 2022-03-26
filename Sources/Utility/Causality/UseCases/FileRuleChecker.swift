import Foundation
import Facility
import FacilityAutomates
import FacilityQueries
public final class FileRuleChecker {
  private let wire: Wire
  public init(wire: Wire) { self.wire = wire }
  public func check(config: Interpreter.Tree) throws {
    let rules = try FileRule.makeArray(tree: config)
    let fileRules = rules.filter { $0.lineCriteria.isEmpty }
    let lineRules = rules.filter { !$0.lineCriteria.isEmpty }
    for file in wire.makeFileIterator().lazy {
      let fileRules = fileRules.compactMap { $0.fileCriteria.isMet(file).then($0.rule) }
      try fileRules.isEmpty.else {
        try wire.reportIssue(.init(
          message: "\(file): " + fileRules.joined(separator: "; "),
          time: wire.getTime()
        ))
      }
      let lineRules = lineRules.filter { $0.fileCriteria.isMet(file) }
      guard !lineRules.isEmpty else { continue }
      for (row, line) in try wire.listFileLines(.init(file: file)).lazy.enumerated() {
        let lineRules = lineRules.compactMap { $0.lineCriteria.isMet(line).then($0.rule) }
        guard !lineRules.isEmpty else { continue }
        try wire.reportIssue(.init(
          message: "\(file) @ \(row): " + lineRules.joined(separator: "; " + "\n\(line)"),
          time: wire.getTime()
        ))
      }
    }
  }
  public struct Wire {
    public var reportIssue: Try.Fetch<ReportIssue>
    public var makeFileIterator: Act.Do<AnyIterator<String>>
    public var listFileLines: Try.Fetch<ListFileLines>
    public var getTime: Act.Do<Date>
    public init(
      reportIssue: @escaping Try.Fetch<ReportIssue>,
      makeFileIterator: @escaping Act.Do<AnyIterator<String>>,
      listFileLines: @escaping Try.Fetch<ListFileLines>,
      getTime: @escaping Act.Do<Date>
    ) {
      self.reportIssue = reportIssue
      self.makeFileIterator = makeFileIterator
      self.listFileLines = listFileLines
      self.getTime = getTime
    }
  }
}
