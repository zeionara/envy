// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Envy",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main"),
        .package(url: "https://github.com/apple/swift-collections", branch: "main"),

        .package(url: "https://github.com/jpsim/Yams", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "envy",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "OrderedCollections", package: "swift-collections"),

                .product(name: "Yams", package: "Yams")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "envy-tests",
            dependencies: ["envy"],
            path: "Tests"
        )
    ]
)
