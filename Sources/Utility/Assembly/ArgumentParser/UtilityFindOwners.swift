import ArgumentParser
import Foundation
import CausalityUseCases
import InteractivityYams
import InteractivityPathKit
extension Utility {
  struct FindOwners: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Find code owners")
    @Option(help: "The path to Utility configuration file.")
    var config = ".Utility.yml"
    mutating func run() throws {
      try OwnageChecker
        .init(wire: .init(
          reportOwnage: { try FileHandle.standardOutput.wrile(message: $0.owner) },
          makeFileIterator: { .init { readLine() }}
        ))
        .findOwners(config: YamlParser.parseYaml(query: .init(
          content: Finder(root: "").readFile(query: .init(file: config))
        )))
    }
  }
}
