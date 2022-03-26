import ArgumentParser
import Foundation
import CausalityUseCases
import InteractivityYams
import InteractivityPathKit
extension Utility {
  struct CheckUnowned: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Find code owners")
    @Option(help: "The path to Utility configuration file.")
    var config = ".Utility.yml"
    mutating func run() throws {
      try UnownedChecker
        .init(wire: .init(
          reportIssue: tracker.reportIssue(query:),
          makeFileIterator: { .init { readLine() }},
          getTime: Date.init
        ))
        .checkUnowned(config: YamlParser.parseYaml(query: .init(
          content: Finder(root: "").readFile(query: .init(file: config))
        )))
      try tracker.ensureNoIssues()
    }
  }
}
