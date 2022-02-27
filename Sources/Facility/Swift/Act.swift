public enum Act {
  public static func vary<T>(_ type: T.Type = T.self, perform: @escaping Vary<T>) -> Vary<T> {
    perform
  }
  public static func apply<T>(to value: T, vary: Vary<T>) -> T {
    var result = value
    vary(&result)
    return result
  }
  public static func apply<T>(into value: inout T, vary: Vary<T>) {
    vary(&value)
  }
  public typealias Send<T> = (T) -> Void
  public typealias Vary<T> = (inout T) -> Void
  public typealias Turn<T> = (T) -> T
  public typealias Work = () -> Void
  public typealias Make<T> = () -> T
  public enum Tune<T> {
    public typealias Do<U> = (T, U) -> T
  }
  public enum To<T> {
    public typealias Do<U> = (T, U) -> Void
  }
  public enum Of<T> {
    public typealias Make<U> = (T) -> U
    public enum Or<U> {
      public typealias Make<V> = (T, U) -> V
    }
  }
  public enum In<T> {
    public typealias Do<U> = (inout T, U) -> Void
  }
  public enum By<C> {
    public typealias Send<T> = (C) -> Act.Send<T>
    public typealias Vary<T> = (C) -> Act.Vary<T>
    public typealias Turn<T> = (C) -> Act.Turn<T>
    public typealias Work = (C) -> Act.Work
    public typealias Make<T> = (C) -> Act.Make<T>
    public enum Tune<T> {
      public typealias Do<U> = (C) -> Act.Tune<T>.Do<T>
    }
    public enum To<T> {
      public typealias Do<U> = (C) -> Act.To<T>.Do<U>
    }
    public enum Of<T> {
      public typealias Make<U> = (C) -> Act.Of<T>.Make<U>
      public enum Or<U> {
        public typealias Make<V> = (C) -> Act.Of<T>.Or<U>.Make<V>
      }
    }
    public enum In<T> {
      public typealias Do<U> = (C) -> Act.In<T>.Do<U>
    }
  }
}
