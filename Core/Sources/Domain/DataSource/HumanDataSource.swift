import ComposableArchitecture
import Moya
import Foundation
import XCTestDynamicOverlay
import Combine

public struct HumanDataSource {
    public var getRandomHuman: @Sendable (HumanRequestDTO) async throws -> [HumanResultEntity]
}

extension DependencyValues {
    public var humanDataSource: HumanDataSource {
        get { self[HumanDataSource.self] }
        set { self[HumanDataSource.self] = newValue }
    }
}

extension HumanDataSource: DependencyKey {
    public static let liveValue = Self(
        getRandomHuman: { dto in
            let dataSource = BaseRemoteDataSource<HumanAPI>()
            var bag = Set<AnyCancellable>()

            return try await withCheckedThrowingContinuation { continuation in
                dataSource.request(.getRandomHuman(request: dto), dto: GetRandomHumanDTO.self)
                    .map { $0.toDomain() }
                    .sink(receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            print(error)
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &bag)
            }
        }
    )
}
