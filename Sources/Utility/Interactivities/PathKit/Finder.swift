import Foundation
import PathKit
import Interactivity
class Finder {
  let project: Path
  init(project: String) {
    self.project = Path(project)
  }
  func makeLineIterator(file: String) throws -> AnyIterator<String> {
    var path = Path(file)
    if path.isRelative { path = project + path }
    return try FileManager.default.readLines(atPath: path.absolute().string)
  }
  func readConfig(file: String) throws -> String {
    try Path(file).absolute().read(.utf8)
  }
}
