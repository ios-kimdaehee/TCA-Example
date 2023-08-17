import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let Moya = TargetDependency.external(name: "Moya")
    static let CombineMoya = TargetDependency.external(name: "CombineMoya")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
    static let ComposableArchitecture = TargetDependency.external(name: "ComposableArchitecture")
}

public extension Package {
}
