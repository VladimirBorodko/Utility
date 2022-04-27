import Foundation
public extension String {
  static func make(utf8 data: Data) throws -> Self {
    try String(data: data, encoding: .utf8).or { throw Thrown("Data not utf8") }
  }
}
