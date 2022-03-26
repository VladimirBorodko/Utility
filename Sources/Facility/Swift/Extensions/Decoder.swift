extension Decoder {
  internal func path(key: CodingKey? = nil) -> String {
    (codingPath + key.makeArray())
      .map { $0.stringValue }
      .joined(separator: ".")
  }
  internal func rethrow<T>(
    key: CodingKey? = nil,
    make: Try.Do<T>
  ) throws -> T {
    try Thrown.rethrow("Decode \(T.self) at " + path(key: key)) {
      try make()
    }
  }
}
