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
    ],
    dependencies: [
        .package(url: "https://github.com/nikolainobadi/NnTestKit", from: "1.0.0"),
        .package(url: "https://github.com/iGetGroceries/iGetGroceriesSharedUI.git", branch: "main")
    ],
    targets: [
        .target(
            name: "iGetGroceriesGroceryItems",
            dependencies: [
                "iGetGroceriesSharedUI"
            ]
        ),
        .testTarget(
            name: "iGetGroceriesGroceryItemsTests",
            dependencies: [
                "iGetGroceriesGroceryItems",
                .product(name: "NnTestHelpers", package: "NnTestKit")
            ]
        ),
    ]
)
