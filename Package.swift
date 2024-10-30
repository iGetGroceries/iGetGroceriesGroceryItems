// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iGetGroceriesGroceryItems",
    platforms: [
        .iOS(.v17), .macOS(.v13)
    ],
    products: [
        .library(
            name: "iGetGroceriesGroceryItems",
            targets: ["iGetGroceriesGroceryItems"]
        ),
        .library(
            name: "iGetGroceriesGroceryItemsAccessibility",
            targets: ["iGetGroceriesGroceryItemsAccessibility"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nikolainobadi/NnTestKit", from: "1.1.0"),
        .package(url: "https://github.com/iGetGroceries/iGetGroceriesSharedUI.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "iGetGroceriesGroceryItems",
            dependencies: [
                "iGetGroceriesSharedUI",
                "iGetGroceriesGroceryItemsAccessibility"
            ]
        ),
        .target(name: "iGetGroceriesGroceryItemsAccessibility"),
        .testTarget(
            name: "iGetGroceriesGroceryItemsTests",
            dependencies: [
                "iGetGroceriesGroceryItems",
                .product(name: "NnTestHelpers", package: "NnTestKit")
            ]
        ),
    ]
)
