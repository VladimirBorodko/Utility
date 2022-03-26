import Foundation
import Stencil
import Facility
import FacilityQueries
public enum StencilParser {
  public static func renderStencil(query: RenderStencil) throws -> RenderStencil.Reply {
    try Template(templateString: query.template)
      .render(query.context)
      .components(separatedBy: .newlines)
      .compactMap { $0.trimmingCharacters(in: .whitespaces).isEmpty.else($0 + "\n") }
      .joined()
      .data(using: .utf8)
      .or { throw MayDay("Data init failed") }
  }
}
