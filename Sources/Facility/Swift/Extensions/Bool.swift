extension Bool {
  public func then<T>(_ make: @autoclosure Try.Do<T>) rethrows -> T? {
    guard self else { return nil }
    return try make()
  }
  public func then<T>(make: Try.Do<T>) rethrows -> T? {
    guard self else { return nil }
    return try make()
  }
  public func `else`<T>(_ make: @autoclosure Try.Do<T>) rethrows -> T? {
    guard !self else { return nil }
    return try make()
  }
  public func `else`<T>(make: Try.Do<T>) rethrows -> T? {
    guard !self else { return nil }
    return try make()
  }
}
