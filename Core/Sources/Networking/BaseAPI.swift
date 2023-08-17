import Moya
import Foundation

public protocol BaseAPI: TargetType {
    var errorMap: [Int: HumanRandomError] { get }
}

public extension BaseAPI {
    var baseURL: URL {
        URL(string: "https://randomuser.me/api/")!
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
