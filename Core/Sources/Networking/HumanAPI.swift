import Moya
import Foundation

public enum HumanAPI {
    case getRandomHuman(request: HumanRequestDTO)
}

extension HumanAPI: BaseAPI {
    public var path: String { return "" }

    public var method: Moya.Method { return .get }

    public var task: Moya.Task {
        switch self {
            case let .getRandomHuman(dto):
                return .requestParameters(
                    parameters: [
                        "gender": dto.gender,
                        "page": dto.page,
                        "results": dto.results
                    ],
                    encoding: URLEncoding.queryString
                )
        }
    }

    public var errorMap: [Int: HumanRandomError] {
        return [
            400: .badRequest,
            500: .serverError
        ]
    }
}
