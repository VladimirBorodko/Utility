/// An error to be ignored
public final class Thrown: Error, CustomStringConvertible {
  public let what: String
  public let file: StaticString
  public let line: UInt
  public init(_ what: String = "", file: StaticString = #file, line: UInt = #line) {
    self.what = what
    self.file = file
    self.line = line
  }
  public var description: String {
    what
  }
  public static func rethrow<T>(
    _ what: @autoclosure Act.Make<String> = "",
    file: StaticString = #file,
    line: UInt = #line,
    make: Try.Make<T>
  ) throws -> T {
    do {
      return try make()
    } catch {
      throw Thrown(what(), file: file, line: line)
    }
  }
}
