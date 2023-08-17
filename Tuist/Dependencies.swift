import ProjectDescription

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager:
        SwiftPackageManagerDependencies(
            [
                .remote(url: "https://github.com/team-aliens/Moya.git", requirement: .branch("master")),
                .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0")),
                .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .upToNextMajor(from: "1.0.0"))
            ]
        ),
    platforms: [.iOS]
)
