import Foundation

public enum HumanRandomError: Error {
    case unknown
    case badRequest
    case notPassword
    case notFound
    case serverError
}

extension HumanRandomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .unknown:
                return "알 수 없는 오류가 발생하였습니다."
            case .badRequest:
                return "요청이 잘못되었습니다."
            case .serverError:
                return "서버에서 문제가 발생하였습니다. 잠시 후 다시 시도해주세요!"
            case .notFound:
                return "정보를 찾을 수 없습니다."
            case .notPassword:
                return "비밀번호가 일치하지 않습니다."
        }
    }
}

public extension Error {
    var asSoopGwanError: HumanRandomError {
        self as? HumanRandomError ?? .unknown
    }
}
