import ArgumentParser
import Foundation
import Interactivity
import Facility
extension Utility {
  struct CheckFileRules: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Check file rules")
    @Option(help: "The path to Utility configuration file.")
    var config = ".Utility.yml"
    @Option(help: "The path to destination directory")
    var project = ""
    mutating func run() throws {
      let finder = try Finder(project: project)
      let checker = FileRuleChecker(wire: .init(
        report: tracker.report(message:),
        makeFileIterator: { AnyIterator({ readLine() }) },
        listLines: finder.listLines(file:)
      ))
      let yaml = try Finder.readContents(file: config)
      let config = try YamlParser.parse(yaml: yaml)
      try checker.check(config: config)
      try tracker.finish()
    }
  }
}
