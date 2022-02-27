public enum Try {
  public static func vary<T>(_ type: T.Type = T.self, perform: @escaping Vary<T>) -> Vary<T> {
    perform
  }
  public static func apply<T>(to value: T, vary: Vary<T>) throws -> T {
    var result = value
    try vary(&result)
    return result
  }
  public static func apply<T>(into value: inout T, vary: Vary<T>) throws {
    try vary(&value)
  }
  public typealias Send<T> = (T) throws -> Void
  public typealias Vary<T> = (inout T) throws -> Void
  public typealias Turn<T> = (T) throws -> T
  public typealias Work = () throws -> Void
  public typealias Make<T> = () throws -> T
  public enum Tune<T> {
    public typealias Do<U> = (T, U) throws -> T
  }
  public enum To<T> {
    public typealias Do<U> = (T, U) throws -> Void
  }
  public enum Of<T> {
    public typealias Make<U> = (T) throws -> U
    public enum Or<U> {
      public typealias Make<V> = (T, U) throws -> V
    }
  }
  public enum In<T> {
    public typealias Do<U> = (inout T, U) throws -> Void
  }
  public enum By<C> {
    public typealias Send<T> = (C) -> Try.Send<T>
    public typealias Vary<T> = (C) -> Try.Vary<T>
    public typealias Turn<T> = (C) -> Try.Turn<T>
    public typealias Work = (C) -> Try.Work
    public typealias Make<T> = (C) -> Try.Make<T>
    public enum Tune<T> {
      public typealias Do<U> = (C) -> Try.Tune<T>.Do<T>
    }
    public enum To<T> {
      public typealias Do<U> = (C) -> Try.To<T>.Do<U>
    }
    public enum Of<T> {
      public typealias Make<U> = (C) -> Try.Of<T>.Make<U>
      public enum Or<U> {
        public typealias Make<V> = (C) -> Try.Of<T>.Or<U>.Make<V>
      }
    }
    public enum In<T> {
      public typealias Do<U> = (C) -> Try.In<T>.Do<U>
    }
  }
}
public func <-<T, U> (
  lhs: Try.Of<T>.Make<U>,
  rhs: T
) rethrows -> U {
  try lhs(rhs)
}
