// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FSEconomyDataFeeds",
    platforms: [
        .iOS(.v15),
         .macOS(.v10_15),
     ],
    products: [
        .library(
            name: "FSEconomyDataFeeds",
            targets: ["FSEconomyDataFeeds"]),
    ],
    dependencies: [
        .package(url: "https://github.com/yaslab/CSV.swift.git", .upToNextMajor(from: "2.4.2")),
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", .upToNextMajor(from: "0.14.0")),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.0")),
    ],
    targets: [
        .target(
            name: "FSEconomyDataFeeds",
            dependencies: [
                .product(name: "CSV", package: "CSV.swift"),
               "XMLCoder",
                "ZIPFoundation",
            ]),
        .testTarget(
            name: "FSEconomyDataFeedsTests",
            dependencies: ["FSEconomyDataFeeds"],
            resources: [
                .copy("Fixtures/AircraftAliasData.xml"),
                .copy("Fixtures/AircraftConfigData.xml"),
                .copy("Fixtures/AircraftItemsData.xml"),
                .copy("Fixtures/AircraftStatusData.xml"),
                .copy("Fixtures/ICAOJobsData.xml"),
                .copy("Fixtures/datafeed_icaodata.zip"),
            ]),
    ]
)
