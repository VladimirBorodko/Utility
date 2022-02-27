import ArgumentParser
import Foundation
struct Utility: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "utility",
    abstract: "Repo house keeping tool",
    version: "0.2.0",
    subcommands: [
      CheckFileRules.self,
    ]
  )
}
