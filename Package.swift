// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
  name: "Utility",
  products: [
    .executable(name: "utility", targets: ["Utility"]),
    .library(name: "Facility", targets: ["Facility"]),
    .library(name: "Interactivity", targets: ["Interactivity"]),
  ],
  dependencies: [
    .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.1"),
    .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.2"),
    .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
  ],
  targets: [
    .executableTarget(
      name: "Utility",
      dependencies: [
        .target(name: "Facility"),
        .target(name: "Interactivity"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Yams", package: "Yams"),
        .product(name: "PathKit", package: "PathKit"),
      ]
    ),
    .target(name: "Facility"),
    .target(name: "Interactivity", dependencies: ["Facility"]),
  ]
)
