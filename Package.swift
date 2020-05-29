// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "KNContactsPicker",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "KNContactsPicker",
            targets: ["KNContactsPicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KNContactsPicker",
            dependencies: []
         ),
        .testTarget(
            name: "KNContactsPickerTests",
            dependencies: ["KNContactsPicker"]
         ),
    ]
)

