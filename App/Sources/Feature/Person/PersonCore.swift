import ComposableArchitecture
import Dependencies
import SwiftUI
import Core

public struct Person: Reducer {
    private enum CancelID { case load }
    private let personGender: GenderEntity

    @Dependency(\.humanDataSource) var humanDataSource

    public enum Action: Equatable {
        case onAppear
        case tapIsCellButton(String)
        case personListResponse(TaskResult<[HumanResultEntity]>)
        case personDetail(PersonDetail.Action)
        case setDetailPicture(pictureURL: URL?)
        case setSheet(isPresented: Bool)
    }

    public struct State: Equatable {
        var isSheetPresented = false
        var isCell = UserDefaults.standard.string(forKey: "isCell") ?? "1단"
        var pictueURL: URL?
        var personDetail: PersonDetail.State?
        var gender: GenderEntity = .male
        var humanResult: [HumanResultEntity] = []
        var page = 1
        var results = 15
    }

    public init(gender: GenderEntity) {
        self.personGender = gender
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case .onAppear:
                    state.gender = personGender

                    return .run { [state = state] send in
                        await send(
                            .personListResponse(
                                TaskResult {
                                    try await self.humanDataSource
                                        .getRandomHuman(HumanRequestDTO(
                                            gender: state.gender.convertGender(),
                                            page: state.page,
                                            results: state.results
                                        ))
                                }
                            )
                        )
                    }

                case .tapIsCellButton(let isCell):
                    state.isCell = isCell
                    UserDefaults.standard.set(isCell, forKey: "isCell")
                    return .none

                case .setDetailPicture(let pictureURL):
                    state.pictueURL = pictureURL
                    return .run { send in
                        await send(.setSheet(isPresented: true))
                    }

                case .personListResponse(.success(let response)):
                    state.humanResult = response
                    return .none

                case .setSheet(isPresented: true):
                    state.isSheetPresented = true
                    state.personDetail = PersonDetail.State(pictureURL: state.pictueURL)
                    return .cancel(id: CancelID.load)

                case .setSheet(isPresented: false):
                    state.isSheetPresented = false
                    state.personDetail = nil
                    return .cancel(id: CancelID.load)

                default:
                    return .none
            }
        }
        .ifLet(\.personDetail, action: /Action.personDetail) {
            PersonDetail()
        }
    }
}
