import Foundation
import Stencil
import Facility
enum StencilParser {
  static func render(template: String, context: [String: Any]) throws -> String {
    try Template.init(templateString: template).render(context)
  }
}
