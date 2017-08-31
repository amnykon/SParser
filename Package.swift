import PackageDescription
 
let package = Package(
  name: "SParser",
  targets: [
    Target(
      name: "SParser",
      dependencies: [
        .Target(name: "SParserPrivate"),
      ]
    ),
    Target(
      name: "SParserPrivate",
      dependencies: [
        .Target(name: "SParserLibs"),
      ]
    ),
    Target(
      name: "SParserLibs"
    ),
  ]
)

