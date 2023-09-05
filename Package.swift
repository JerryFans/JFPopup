// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JFPopup",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "JFPopup",
            targets: ["JFPopup"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JerryFans/JRBaseKit.git", from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "JFPopup",
            dependencies: [
              .product(name: "JRBaseKit", package: "JRBaseKit")
            ],
            path: "JFPopup/Classes")
    ]
)
