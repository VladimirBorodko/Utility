import Foundation
import Facility
import FacilityAutomates
import FacilityQueries
public final class ConformistGenerator {
  private let wire: Wire
  public init(wire: Wire) { self.wire = wire }
  public func generate(directory: String = "", template: String? = nil) throws {
    let template = (try? wire.readFile(.init(file: directory + "Template.stencil"))) ?? template
    for file in try wire.listFileSystem(.init(path: directory, include: .files)) {
      guard file.hasSuffix(".yml") else { continue }
      guard let template = template else { throw MayDay("No template in hierarchy \(directory)") }
      let config = try wire.readFile(.init(file: directory + file))
      let tree = try wire.parseYaml(.init(content: config))
      let context = try Conformism.makeContext(tree: tree)
      let result = try wire.renderStencil(.init(template: template, context: context))
      let file = directory + file.replacingOccurrences(of: ".yml", with: ".swift")
      try wire.createFile(.init(file: file, data: result))
    }
    for subdirectory in try wire.listFileSystem(.init(path: directory, include: .directories)) {
      try generate(directory: directory + subdirectory + "/", template: template)
    }
  }
  public struct Wire {
    public var readFile: Try.Fetch<ReadFile>
    public var createFile: Try.Fetch<CreateFile>
    public var listFileSystem: Try.Fetch<ListFileSystem>
    public var parseYaml: Try.Fetch<ParseYaml>
    public var renderStencil: Try.Fetch<RenderStencil>
    public init(
      readFile: @escaping Try.Fetch<ReadFile>,
      createFile: @escaping Try.Fetch<CreateFile>,
      listFileSystem: @escaping Try.Fetch<ListFileSystem>,
      parseYaml: @escaping Try.Fetch<ParseYaml>,
      renderStencil: @escaping Try.Fetch<RenderStencil>
    ) {
      self.readFile = readFile
      self.createFile = createFile
      self.listFileSystem = listFileSystem
      self.parseYaml = parseYaml
      self.renderStencil = renderStencil
    }
  }
}
