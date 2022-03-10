import Foundation
import Facility
final class ConformistGenerator {
  let wire: Wire
  init(wire: Wire) { self.wire = wire }
  func generate(directory: String = "", template: String? = nil) throws {
    let template = (try? wire.readFile(directory + "Template.stencil")) ?? template
    for file in try wire.listFiles(directory) {
      guard file.hasSuffix(".yml") else { continue }
      guard let template = template else { throw MayDay("No template up in \(directory)") }
      let config = try wire.readFile(directory + file)
      let tree = try wire.parseYaml(config)
      let context = try Conformism.makeContext(tree: tree)
      let result = try wire.renderTemplate(template, context)
        .choppingNewLines()
        .data(using: .utf8)
        .or { throw MayDay("Data init failed") }
      let file = directory + file.replacingOccurrences(of: ".yml", with: ".swift")
      try wire.writeFile(file, result)
    }
    for subdirectory in try wire.listDirectories(directory) {
      try generate(directory: directory + subdirectory + "/", template: template)
    }
  }
  struct Wire {
    var readFile: Try.Of<String>.Do<String>
    var writeFile: Try.Of<String>.Of<Data>.Go
    var listDirectories: Try.Of<String>.Do<AnyIterator<String>>
    var listFiles: Try.Of<String>.Do<AnyIterator<String>>
    var parseYaml: Try.Of<String>.Do<Interpreter.Tree>
    var renderTemplate: Try.Of<String>.Of<[String: Any]>.Do<String>
  }
}
