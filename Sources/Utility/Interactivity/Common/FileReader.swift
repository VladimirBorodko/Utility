import Foundation
import Facility
public class FileReader {
  private let file: UnsafeMutablePointer<FILE>
  private var buffer: UnsafeMutablePointer<CChar>? = nil
  private var size = 0
  public init(file: String) throws {
    self.file = try fopen(file, "r").or { throw Thrown("Unable to open \(file)") }
  }
  public func readLine() -> String? {
    guard getline(&buffer, &size, file) > 0 else { return nil }
    return try? String(cString: ?!buffer).trimmingCharacters(in: .newlines)
  }
  deinit {
    fclose(file)
    guard let buffer = buffer else { return }
    buffer.deinitialize(count: size)
    buffer.deallocate()
  }
}
