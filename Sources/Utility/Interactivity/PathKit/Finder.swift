import Foundation
import PathKit
import Interactivity
import Facility
import FacilityQueries
import InteractivityCommon
public final class Finder {
  private let root: Path
  private let fileManager: FileManager
  public init(root: String, fileManager: FileManager = .default) {
    self.root = Path(root).absolute()
    self.fileManager = fileManager
  }
  public func listFileLines(query: ListFileLines) throws -> ListFileLines.Reply {
    var path = Path(query.file)
    if path.isRelative { path = root + path }
    path = path.absolute()
    guard fileManager.fileExists(atPath: path.string) else {
      throw Thrown("FileManager: no \(path.string)")
    }
    guard fileManager.isReadableFile(atPath: path.string) else {
      throw Thrown("FileManager: no read permission \(path.string)")
    }
    let context = try FileReader(file: path.string)
    return .init(context.readLine)
  }
  public func readFile(query: ReadFile) throws -> ReadFile.Reply {
    var path = Path(query.file)
    if path.isRelative { path = root + path }
    return try path.absolute().read(.utf8)
  }
  public func createFile(query: CreateFile) throws -> CreateFile.Reply {
    var path = Path(query.file)
    if path.isRelative { path = root + path }
    try path.parent().absolute().mkpath()
    path = path.absolute()
    try fileManager
      .createFile(atPath: path.string, contents: query.data)
      .else { throw MayDay("Write error \(path.string)") }
  }
  public func delete(path: String) throws {
    var path = Path(path)
    if path.isRelative { path = root + path }
    path = path.absolute()
    if path.exists { try path.delete() }
  }
  public func listFileSystem(query: ListFileSystem) throws -> ListFileSystem.Reply {
    var path = Path(query.path)
    if path.isRelative { path = root + path }
    try ensure(isDirectory: path)
    let children = try path.children().compactMap { child in
      (query.include.files && child.isFile).then(child.lastComponent)
      ?? (query.include.directories && child.isDirectory).then(child.lastComponent)
    }
    return AnyIterator(children.makeIterator())
  }
  func ensure(isDirectory path: Path) throws {
    try path.isDirectory.else { throw MayDay("Not a directory \(path.absolute().string)") }
  }
}
