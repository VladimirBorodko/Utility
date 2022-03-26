import Foundation
import Facility
import CausalityServices
import InteractivityCommon
let tracker = IssueTracker(wire: .init(logLine: FileHandle.standardError.wrile(message:)))
MayDay.sideEffect = {
  try! tracker.reportIssue(query: .init(
    message: "Fatal: \($0.what)",
    time: .init(),
    count: false
  ))
}
Utility.main()
