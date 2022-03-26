import ArgumentParser
import Foundation
import CausalityUseCases
import InteractivityYams
import InteractivityPathKit
extension Utility {
  struct CheckFileRules: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Check file rules")
    @Option(help: "The path to Utility configuration file.")
    var config = ".Utility.yml"
    @Option(help: "The path to destination directory")
    var project = ""
    mutating func run() throws {
      try FileRuleChecker
        .init(wire: .init(
          reportIssue: tracker.reportIssue(query:),
          makeFileIterator: { .init { readLine() }},
          listFileLines: Finder(root: project).listFileLines(query:),
          getTime: Date.init
        ))
        .check(config: YamlParser.parseYaml(query: .init(
          content: Finder(root: "").readFile(query: .init(file: config))
        )))
      try tracker.ensureNoIssues()
    }
  }
}
