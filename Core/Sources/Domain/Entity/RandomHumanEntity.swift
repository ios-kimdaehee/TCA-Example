import Foundation

// MARK: - RandomHumanEntity
struct RandomHumanEntity {
    let results: [HumanResultEntity]
}

// MARK: - HumanResultEntity
public struct HumanResultEntity: Equatable, Hashable, Identifiable {
    public let gender: GenderEntity
    public let name: String
    public let location: String
    public let email: String
    public let userName: String
    public let phone, cell: String
    public let id: String
    public let picture: URL?
    public let nat: String

    public static func == (lhs: HumanResultEntity, rhs: HumanResultEntity) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - DobEntity
public struct DobEntity {
    let date: String
    let age: Int
}

public enum GenderEntity: String {
    case female = "여자"
    case male = "남자"

    public func convertGender() -> Gender {
        switch self {
            case .female:
                return .female
            case .male:
                return .male
        }
    }

}
