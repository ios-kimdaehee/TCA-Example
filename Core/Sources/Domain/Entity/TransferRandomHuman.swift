import Foundation

extension GetRandomHumanDTO {
    func toDomain() -> [HumanResultEntity] {
        results.map { $0.toDomain() }
    }
}

extension Results {
    func toDomain() -> HumanResultEntity {
        return HumanResultEntity(
            gender: gender.rawValue == "female" ? .female : .male,
            name: "\(name.title), \(name.first) \(name.last)",
            location: location.country,
            email: email,
            userName: login.username,
            phone: phone,
            cell: cell,
            id: id.name + name.title + name.last + email, // 고유한 값을 나오게 하기 위함
            picture: URL(string: picture.large),
            nat: nat
        )
    }
}
