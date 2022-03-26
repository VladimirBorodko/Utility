// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
import Foundation
let package = Package(
  name: "Utility",
  products: [
    .executable(name: "utility", targets: ["Utility"]),
    .library(name: "Facility", targets: ["Facility"]),
    .library(name: "Interactivity", targets: ["Interactivity"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.1"),
    .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.2"),
    .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
    .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.14.1"),
  ],
  targets: [
    .executableTarget(
      name: "Utility",
      dependencies: .assembly + [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
      path: "Sources/Utility/Assembly"
    ),
    .interactivity("PathKit", extra: [
      "PathKit",
      "InteractivityCommon",
    ]),
    .interactivity("Yams", extra: [
      "Yams",
    ]),
    .interactivity("Stencil", extra: [
      "Stencil",
    ]),
    .interactivity("Common"),
    .target(name: "Interactivity", dependencies: .facility),
    .causality("UseCases"),
    .causality("Services"),
    .facility("Automates"),
    .facility("Queries"),
    .target(name: "Facility"),
  ]
)
extension Target {
  static func interactivity(_ name: String, extra dependencies: [Dependency] = []) -> Target {
    utility("Interactivity", name, dependencies + .interactivity + .facilities)
  }
  static func causality(_ name: String, extra dependencies: [Dependency] = []) -> Target {
    utility("Causality", name, dependencies + .causality + .facilities)
  }
  static func facility(_ name: String, extra dependencies: [Dependency] = []) -> Target {
    utility("Facility", name, dependencies)
  }
  private static func utility(
    _ layer: String,
    _ name: String,
    _ dependencies: [Dependency]
  ) -> Target {
    self.target(
      name: "\(layer)\(name)",
      dependencies: dependencies + .facility,
      path: "Sources/Utility/\(layer)/\(name)"
    )
  }
}
extension Array where Element == Target.Dependency {
  static let assembly: Self = facility + facilities + causalities + interactivity + interactivities
  static let interactivities: Self = [
    "InteractivityCommon",
    "InteractivityPathKit",
    "InteractivityStencil",
    "InteractivityYams",
  ]
  static let interactivity: Self = [
    "Interactivity",
  ]
  static let causalities: Self = [
    "CausalityServices",
    "CausalityUseCases",
  ]
  static let causality: Self = [
  ]
  static let facilities: Self = [
    "FacilityAutomates",
    "FacilityQueries",
  ]
  static let facility: Self = [
    "Facility",
  ]
}
