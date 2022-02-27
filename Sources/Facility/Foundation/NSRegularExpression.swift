import Foundation
extension NSRegularExpression {
  public convenience init(oneLiner: String) throws {
    do {
      try self.init(pattern: oneLiner, options: [.anchorsMatchLines])
    } catch {
      throw Thrown("Incorrect regexp: \(oneLiner)")
    }
  }
}
