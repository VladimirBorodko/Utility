extension Optional {
  public func or(_ make: @autoclosure Try.Do<Wrapped>) rethrows -> Wrapped {
    try self ?? make()
  }
  public func or(make: Try.Do<Wrapped>) rethrows -> Wrapped {
    try self ?? make()
  }
  public func mapNil(_ make: @autoclosure Act.Do<Wrapped>) -> Optional {
    self ?? make()
  }
  public func mapNil(make: Try.Do<Wrapped>) rethrows -> Optional {
    try self ?? make()
  }
  public func flatMapNil(_ make: @autoclosure Act.Do<Optional>) -> Optional {
    self ?? make()
  }
  public func flatMapNil(make: Try.Do<Optional>) rethrows -> Optional {
    try self ?? make()
  }
  public func filter(isIncluded: Try.Of<Wrapped>.Do<Bool>) rethrows -> Optional {
    if let wrapped = self {
      return try isIncluded(wrapped) ? wrapped : nil
    } else {
      return nil
    }
  }
  public func makeArray() -> [Wrapped] {
    if let wrapped = self {
      return [wrapped]
    } else {
      return []
    }
  }
  public static prefix func ?! (value: Self) throws -> Wrapped {
    if let value = value { return value } else { throw Thrown() }
  }
}
