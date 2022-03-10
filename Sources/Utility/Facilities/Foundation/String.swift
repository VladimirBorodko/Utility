import Foundation
extension String {
  func choppingNewLines() -> String {
    var result = self.trimmingCharacters(in: .newlines)
    var count = result.count
    while true {
      result = result.replacingOccurrences(of: "\n\n", with: "\n")
      let newCount = result.count
      guard count != newCount else { break }
      count = newCount
    }
    return result + "\n"
  }
}
