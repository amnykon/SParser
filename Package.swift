// swift-tools-version:4.0
import PackageDescription
 
let package = Package(
  name: "SParser",
  products: [
    .executable(name: "SParser", targets: ["SParser"]),
    .library(name: "SParserLibs", targets: ["SParserLibs"]),
  ],
  targets: [
    .target(
      name: "SParser",
      dependencies: [
        .target(name: "SParserPrivate"),
      ]
    ),
    .target(
      name: "SParserPrivate",
      dependencies: [
        .target(name: "SParserLibs"),
      ]
    ),
    .target(
      name: "SParserLibs"
    ),
  ]
)
