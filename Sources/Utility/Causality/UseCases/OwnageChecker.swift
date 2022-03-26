import Foundation
import Facility
import FacilityAutomates
import FacilityQueries
public final class OwnageChecker {
  private let wire: Wire
  public init(wire: Wire) { self.wire = wire }
  public func findOwners(config: Interpreter.Tree) throws {
    var owners = try CodeOwner.makeArray(tree: config)
    for file in wire.makeFileIterator().lazy {
      owners = try owners.filter { owner in
        guard owner.ownage.isMet(file) else { return true }
        try wire.reportOwnage(.init(owner: owner.name))
        return false
      }
    }
  }
  public struct Wire {
    public var reportOwnage: Try.Fetch<ReportOwnage>
    public var makeFileIterator: Act.Do<AnyIterator<String>>
    public init(
      reportOwnage: @escaping Try.Fetch<ReportOwnage>,
      makeFileIterator: @escaping Act.Do<AnyIterator<String>>
    ) {
      self.reportOwnage = reportOwnage
      self.makeFileIterator = makeFileIterator
    }
  }
}
