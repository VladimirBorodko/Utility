import Foundation
import Interactivity
import Facility
let tracker = IssueTracker.init(putLine: FileHandle.stdErr(message:))
MayDay.sideEffect = { tracker.report(message: "Fatal: " + $0.what) }
Utility.main()
