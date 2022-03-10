import Foundation
extension Interpreter {
  public struct Dialect {
    private var map: [ObjectIdentifier: Any] = [:]
    public init() {}
    public subscript<T>(_ meta: T.Type = T.self) -> Try.Of<Decoder>.Do<T>? {
      get { map[.init(meta as Any.Type)] as? Try.Of<Decoder>.Do<T> }
      set { map[.init(meta as Any.Type)] = newValue }
    }
    public static var json: Self {
      var this = Self()
      this[URL.self] = { decoder in
        try decoder.rethrow {
          try ?!URL(string: decoder.singleValueContainer().decode(String.self))
        }
      }
      this[Data.self] = { decoder in
        try decoder.rethrow {
          try ?!Data(base64Encoded: decoder.singleValueContainer().decode(String.self))
        }
      }
      this[Date.self] = { decoder in
        try decoder.rethrow {
          try Date(timeIntervalSince1970: decoder.singleValueContainer().decode(Double.self))
        }
      }
      return this
    }
  }
}
