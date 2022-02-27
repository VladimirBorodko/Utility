extension RangeReplaceableCollection where Self: BidirectionalCollection {
  public var end: Element {
    get { self[index(before: endIndex)] }
    set { replaceSubrange(index(before: endIndex)..<endIndex, with: [newValue]) }
  }
}
