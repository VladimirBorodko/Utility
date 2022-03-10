import Foundation
import Facility
extension NSRegularExpression {
  convenience init(oneLiner: String) throws {
    do {
      try self.init(pattern: oneLiner, options: [.anchorsMatchLines])
    } catch {
      throw Thrown("Incorrect regexp: \(oneLiner)")
    }
  }
}
