import Foundation
import Facility
extension FileManager {
  public func readLines(atPath path: String) throws -> AnyIterator<String> {
    guard fileExists(atPath: path) else {
      throw Thrown("FileManager: no \(path)")
    }
    guard isReadableFile(atPath: path) else {
      throw Thrown("FileManager: no read permission \(path)")
    }
    guard let file = fopen(path, "r") else {
      throw Thrown("FileManager: unable to open \(path)")
    }
    let context = FileReadContext(file: file)
    return .init {
      guard getline(&context.buffer, &context.size, context.file) > 0 else { return nil }
      return try? String(cString: ?!context.buffer).trimmingCharacters(in: .newlines)
    }
  }
  class FileReadContext {
    let file: UnsafeMutablePointer<FILE>
    var buffer: UnsafeMutablePointer<CChar>? = nil
    var size = 0
    init(file: UnsafeMutablePointer<FILE>) {
      self.file = file
    }
    deinit {
      fclose(file)
      guard let buffer = buffer else { return }
      buffer.deinitialize(count: size)
      buffer.deallocate()
    }
  }
}
