import ArgumentParser
import Foundation
import CausalityUseCases
import InteractivityYams
import InteractivityPathKit
import InteractivityStencil
extension Utility {
  struct GenerateConformist: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Generate Conformist sources")
    @Option(help: "Path to templates directory")
    var templates = "Support/Conformist"
    @Option(help: "Path to products directory")
    var products = "Sources/Interactivity/ConformistGenerated"
    mutating func run() throws {
      let input = Finder(root: templates)
      let output = Finder(root: products)
      try output.delete(path: "")
      let generator = ConformistGenerator(wire: .init(
        readFile: input.readFile(query:),
        createFile: output.createFile(query:),
        listFileSystem: input.listFileSystem(query:),
        parseYaml: YamlParser.parseYaml(query:),
        renderStencil: StencilParser.renderStencil(query:)
      ))
      try generator.generate()
    }
  }
}
