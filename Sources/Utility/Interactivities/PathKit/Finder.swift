import Foundation
import PathKit
import Interactivity
import Facility
final class Finder {
  let project: Path
  let fileManager: FileManager
  init(project: String, fileManager: FileManager = .default) throws {
    self.project = Path(project).absolute()
    self.fileManager = fileManager
  }
  func listLines(file: String) throws -> AnyIterator<String> {
    var path = Path(file)
    if path.isRelative { path = project + path }
    return try fileManager.readLines(atPath: path.absolute().string)
  }
  func readContents(file: String) throws -> String {
    var path = Path(file)
    if path.isRelative { path = project + path }
    return try path.absolute().read(.utf8)
  }
  func writeContents(file: String, data: Data) throws {
    var path = Path(file)
    if path.isRelative { path = project + path }
    try path.parent().absolute().mkpath()
    path = path.absolute()
    try fileManager
      .createFile(atPath: path.string, contents: data)
      .else { throw MayDay("Write error \(path.string)") }
  }
  func delete(path: String) throws {
    var path = Path(path)
    if path.isRelative { path = project + path }
    path = path.absolute()
    if path.exists { try path.delete() }
  }
  func listDirectories(path: String) throws -> AnyIterator<String> {
    var path = Path(path)
    if path.isRelative { path = project + path }
    try ensure(isDirectory: path)
    let children = try path.children()
      .compactMap { $0.isDirectory.then($0.lastComponent) }
      .makeIterator()
    return AnyIterator(children)
  }
  func listFiles(path: String) throws -> AnyIterator<String> {
    var path = Path(path)
    if path.isRelative { path = project + path }
    try ensure(isDirectory: path)
    let children = try path.children()
      .compactMap { $0.isFile.then($0.lastComponent) }
      .makeIterator()
    return AnyIterator(children)
  }
  func ensure(isDirectory path: Path) throws {
    try path.isDirectory.else { throw MayDay("Not a directory \(path.absolute().string)") }
  }
  static func readContents(file: String) throws -> String {
    try Path(file).absolute().read(.utf8)
  }
}
