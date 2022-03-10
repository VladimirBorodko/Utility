import Foundation
import Facility
public protocol ConformistRequest {
  associatedtype Response
  static var conform: Protocol { get }
  static var respond: Selector { get }
  static func makeResopnder(
    handle: @escaping Act.Of<Self>.Do<Response>
  ) -> Conformist.Responder<Self>
}
