import Foundation
import Facility
import FacilityAutomates
import FacilityQueries
public final class UnownedChecker {
  private let wire: Wire
  public init(wire: Wire) { self.wire = wire }
  public func checkUnowned(config: Interpreter.Tree) throws {
    let owners = try CodeOwner.makeArray(tree: config)
    fileLoop: for file in wire.makeFileIterator().lazy {
      for owner in owners where owner.ownage.isMet(file) { continue fileLoop }
      try wire.reportIssue(.init(
        message: "Unowned: " + file,
        time: wire.getTime()
      ))
    }
  }
  public struct Wire {
    public var reportIssue: Try.Fetch<ReportIssue>
    public var makeFileIterator: Act.Do<AnyIterator<String>>
    public var getTime: Act.Do<Date>
    public init(
      reportIssue: @escaping Try.Fetch<ReportIssue>,
      makeFileIterator: @escaping Act.Do<AnyIterator<String>>,
      getTime: @escaping Act.Do<Date>
    ) {
      self.reportIssue = reportIssue
      self.makeFileIterator = makeFileIterator
      self.getTime = getTime
    }
  }
}
