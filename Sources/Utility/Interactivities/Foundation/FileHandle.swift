import Foundation
extension FileHandle {
  public static func stdErr(message: String) {
    "\(message)\n"
      .data(using: .utf8)
      .map(FileHandle.standardError.write)
  }
}
