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
      let tracker = IssueTracker.init(putLine: FileHandle.stdErr(message:))
      MayDay.sideEffect = { tracker.report(message: "Fatal: " + $0.what) }
      let finder = Finder(project: project)
      let configurator = try Configurator(config: finder.readConfig(file: config))
      let checker = FileRuleChecker(
        rules: try configurator.makeFileRules(),
        report: tracker.report(message:),
        makeFileIterator: { AnyIterator({ readLine() }) },
        makeLineIterator: finder.makeLineIterator(file:)
      )
      try checker.check()
      try tracker.finish()
    }
  }
}
