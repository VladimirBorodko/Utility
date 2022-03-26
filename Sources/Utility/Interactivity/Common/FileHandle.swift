import Foundation
import Facility
extension FileHandle {
  public func wrile(message: String) throws {
    try "\(message)\n"
      .data(using: .utf8)
      .map(write)
      .or { throw MayDay("utf8 conversion: \(message)") }
  }
}
