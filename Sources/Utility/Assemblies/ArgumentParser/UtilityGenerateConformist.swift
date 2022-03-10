import ArgumentParser
import Foundation
import Interactivity
import Facility
extension Utility {
  struct GenerateConformist: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Generate Conformist sources")
    @Option(help: "Path to templates directory")
    var templates = "Support/Conformist"
    @Option(help: "Path to products directory")
    var products = "Sources/Interactivity/ConformistGenerated"
    mutating func run() throws {
      let input = try Finder(project: templates)
      let output = try Finder(project: products)
      try output.delete(path: "")
      let generator = ConformistGenerator(wire: .init(
        readFile: input.readContents(file:),
        writeFile: output.writeContents(file:data:),
        listDirectories: input.listDirectories(path:),
        listFiles: input.listFiles(path:),
        parseYaml: YamlParser.parse(yaml:),
        renderTemplate: StencilParser.render(template:context:)
      ))
      try generator.generate()
    }
  }
}
