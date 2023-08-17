import ProjectDescription

extension Project{
    public static func excutable(
        name: String,
        platform: Platform,
        product: Product = .app,
        deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone, .iphone]),
        dependencies: [TargetDependency]
    ) -> Project {
        return Project(
            name: name,
            organizationName: dmsOrganizationName,
            settings: .settings(base: .codeSign),
            targets: [
                
                Target(
                    name: name,
                    platform: platform,
                    product: product,
                    bundleId: "\(dmsOrganizationName).\(name)",
                    deploymentTarget: deploymentTarget,
                    infoPlist: .file(path: Path("Support/Info.plist")),
                    sources: ["Sources/**"],
                    resources: ["Resources/**"],
                    scripts: [],
                    dependencies: [
                        .project(target: "ThirdPartyLib", path: "../ThirdPartyLib"),
                        .project(target: "Core", path: "../Core")
                    ] + dependencies
                )
            ]
        )
    }
}
