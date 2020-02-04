// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Loaders",
    products: [
        .library(
            name: "Loaders",
            targets: ["Loaders"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Loaders",
            dependencies: [],
            path: "Loaders/Sources",
            exclude: []),
    ]
)