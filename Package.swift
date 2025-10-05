// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AgniKit",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9),
    .visionOS(.v1)
  ],
  products: [
    .library(
      name: "AgniKit",
      type: .static,
      targets: ["AgniKit"]
    )
  ],
  targets: [
    .target(name: "AgniKit"),
    .testTarget(
      name: "AgniKitTests",
      dependencies: ["AgniKit"]
    )
  ]
)
