// swift-tools-version:5.7.1
import PackageDescription

let package = Package(
  name: "DeckOfCards",
  defaultLocalization: "en",
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint.git", exact: "0.52.4") // Last version that supports 5.7
  ]
)
