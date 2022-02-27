extension Optional {
  public func or(_ make: @autoclosure Try.Make<Wrapped>) rethrows -> Wrapped {
    try self ?? make()
  }
  public func or(make: Try.Make<Wrapped>) rethrows -> Wrapped {
    try self ?? make()
  }
  public func mapNil(_ make: @autoclosure Act.Make<Wrapped>) -> Optional {
    self ?? make()
  }
  public func mapNil(make: Try.Make<Wrapped>) rethrows -> Optional {
    try self ?? make()
  }
  public func flatMapNil(_ make: @autoclosure Act.Make<Optional>) -> Optional {
    self ?? make()
  }
  public func flatMapNil(make: Try.Make<Optional>) rethrows -> Optional {
    try self ?? make()
  }
  public func filter(isIncluded: Try.Of<Wrapped>.Make<Bool>) rethrows -> Optional {
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
