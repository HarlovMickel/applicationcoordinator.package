// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ApplicationCoordinator",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ApplicationCoordinator",
            targets: ["ApplicationCoordinator"])
    ],
    dependencies: [
        .package(url: "https://github.com/HarlovMickel/extensions.package.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "ApplicationCoordinator",
            dependencies: [
                .product(name: "Extensions", package: "extensions.package")
            ])
    ]
)
