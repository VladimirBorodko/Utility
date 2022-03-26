import ArgumentParser
import Foundation
struct Utility: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "utility",
    abstract: "Repo house keeping tool",
    version: "0.4.0",
    subcommands: [
      CheckFileRules.self,
      GenerateConformist.self,
      FindOwners.self,
      CheckUnowned.self
    ]
  )
}
