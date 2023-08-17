import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.dynamicFramework(
    name: "ThirdPartyLib",
    deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
    dependencies: [
        .SPM.ComposableArchitecture,
        .SPM.Moya,
        .SPM.CombineMoya,
        .SPM.Kingfisher
    ]
)
