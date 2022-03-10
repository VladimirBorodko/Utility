import Foundation
import Facility
final class FileRuleChecker {
  private let wire: Wire
  init(wire: Wire) { self.wire = wire }
  func check(config: Interpreter.Tree) throws {
    let rules = try FileRule.make(tree: config)
    let fileRules = rules.filter { $0.lineCriteria.isEmpty }
    let lineRules = rules.filter { !$0.lineCriteria.isEmpty }
    for file in try wire.makeFileIterator().lazy {
      let fileRules = fileRules.compactMap { $0.fileCriteria.isMet(file).then($0.rule) }
      fileRules.isEmpty.else { wire.report("\(file): " + fileRules.joined(separator: "; ")) }
      let lineRules = lineRules.filter { $0.fileCriteria.isMet(file) }
      guard !lineRules.isEmpty else { continue }
      for (row, line) in try wire.listLines(file).lazy.enumerated() {
        let lineRules = lineRules.compactMap { $0.lineCriteria.isMet(line).then($0.rule) }
        guard !lineRules.isEmpty else { continue }
        wire.report("\(file) @ \(row): " + lineRules.joined(separator: "; "))
        wire.report(line)
      }
    }
  }
  struct Wire {
    var report: Act.Of<String>.Go
    var makeFileIterator: Try.Do<AnyIterator<String>>
    var listLines: Try.Of<String>.Do<AnyIterator<String>>
  }
}
