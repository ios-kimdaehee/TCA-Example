import Combine
import CombineMoya
import Foundation
import Moya

// MARK: - BaseRemoteDataSource
public class BaseRemoteDataSource<API: BaseAPI> {
    private let provider: MoyaProvider<API>
    private let decoder = JSONDecoder()
    private let maxRetryCount = 3

    public init(
        provider: MoyaProvider<API>? = nil
    ) {
        #if DEBUG
        self.provider = provider ?? MoyaProvider(plugins: [NetworkLoggerPlugin()])
        #else
        self.provider = provider ?? MoyaProvider(plugins: [])
        #endif
    }

    public func request<T: Decodable>(_ api: API, dto: T.Type) -> AnyPublisher<T, HumanRandomError> {
        requestPublisher(api).map(dto, using: decoder)
    }

    public func request(_ api: API) -> AnyPublisher<Void, HumanRandomError> {
        requestPublisher(api)
            .map { _ in return }
            .eraseToAnyPublisher()
    }

    private func requestPublisher(_ api: API) -> AnyPublisher<Response, HumanRandomError> {
        return provider.requestPublisher(api, callbackQueue: .main)
            .retry(maxRetryCount)
            .timeout(45, scheduler: DispatchQueue.main)
            .mapError {
                return api.errorMap[$0.response?.statusCode ?? 0] ?? .unknown
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - AnyPublisher + map
extension AnyPublisher where Output == Moya.Response, Failure == HumanRandomError {
    func map<D: Decodable>(
        _ type: D.Type,
        atKeyPath keyPath: String? = nil,
        using decoder: JSONDecoder = JSONDecoder(),
        failsOnEmptyData: Bool = true
    ) -> AnyPublisher<D, HumanRandomError> {
        return unwrapThrowable { response in
            try response.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
        }
    }
}

extension AnyPublisher where Failure == HumanRandomError {
    func unwrapThrowable<T>(throwable: @escaping (Output) throws -> T) -> AnyPublisher<T, HumanRandomError> {
        self.tryMap { element in
            try throwable(element)
        }
        .mapError { $0.asSoopGwanError }
        .eraseToAnyPublisher()
    }
}
