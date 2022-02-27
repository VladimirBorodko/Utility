import Foundation
import Facility
class FileRuleChecker {
  private let fileRules: [FileRule]
  private let lineRules: [FileRule]
  private let report: Act.Send<String>
  private let makeFileIterator: Try.Make<AnyIterator<String>>
  private let makeLineIterator: Try.Of<String>.Make<AnyIterator<String>>
  init(
    rules: [FileRule],
    report: @escaping Act.Send<String>,
    makeFileIterator: @escaping Try.Make<AnyIterator<String>>,
    makeLineIterator: @escaping Try.Of<String>.Make<AnyIterator<String>>
  ) {
    self.report = report
    self.makeFileIterator = makeFileIterator
    self.makeLineIterator = makeLineIterator
    self.fileRules = rules.filter { $0.lineCriteria.isEmpty }
    self.lineRules = rules.filter { !$0.lineCriteria.isEmpty }
  }
  func check() throws {
    for file in try makeFileIterator().lazy {
      let fileRules = fileRules.compactMap { $0.fileCriteria.isMet(file).then($0.rule) }
      fileRules.isEmpty.else { report("\(file): " + fileRules.joined(separator: "; ")) }
      let lineRules = lineRules.filter { $0.fileCriteria.isMet(file) }
      guard !lineRules.isEmpty else { continue }
      for (row, line) in try makeLineIterator(file).lazy.enumerated() {
        let lineRules = lineRules.compactMap { $0.lineCriteria.isMet(line).then($0.rule) }
        guard !lineRules.isEmpty else { continue }
        report("\(file) @ \(row): " + lineRules.joined(separator: "; "))
        report(line)
      }
    }
  }
}
