extension Bool {
  public func then<T>(_ make: @autoclosure Try.Make<T>) rethrows -> T? {
    guard self else { return nil }
    return try make()
  }
  public func then<T>(make: Try.Make<T>) rethrows -> T? {
    guard self else { return nil }
    return try make()
  }
  public func `else`<T>(_ make: @autoclosure Try.Make<T>) rethrows -> T? {
    guard !self else { return nil }
    return try make()
  }
  public func `else`<T>(make: Try.Make<T>) rethrows -> T? {
    guard !self else { return nil }
    return try make()
  }
}
