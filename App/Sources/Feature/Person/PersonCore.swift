import ComposableArchitecture
import Dependencies
import SwiftUI
import Core

public struct Person: Reducer {
    private enum CancelID { case load }
    private let personGender: GenderEntity

    @Dependency(\.humanDataSource) var humanDataSource

    public struct State: Equatable {
        @PresentationState var personDetail: PersonDetail.State?
        @PresentationState var alert: AlertState<Action.Alert>?

        var isSheetPresented = false
        var isCell = UserDefaults.standard.string(forKey: "isCell") ?? "1단"
        var pictueURL: URL?
        var gender: GenderEntity = .male
        var wollRemoveEntity: HumanResultEntity?
        var humanResult: [HumanResultEntity] = []
        var page = 1
        var results = 15
    }

    public enum Action: Equatable {
        case onAppear
        case tapIsCellButton(String)
        case setDetailPicture(pictureURL: URL?)
        case longTapCell(HumanResultEntity)
        case personListResponse(TaskResult<[HumanResultEntity]>)
        case personDetail(PresentationAction<PersonDetail.Action>)
        case alert(PresentationAction<Alert>)

        public enum Alert: Equatable {
          case removeButtonTaped(HumanResultEntity)
        }
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
                    state.personDetail = PersonDetail.State(pictureURL: state.pictueURL)
                    return .none

                case .longTapCell(let entity):
                    print(entity)
                    state.alert = AlertState {
                        TextState("정말로 이 항목을 삭제하시겠습니까?")
                    } actions: {
                        ButtonState(
                            role: .destructive,
                            action: .send(.removeButtonTaped(entity), animation: .default)
                        ) {
                            TextState("삭제")
                        }
                        ButtonState(role: .cancel) {
                            TextState("취소")
                        }
                    }
                    return .none

                case .alert(.presented(.removeButtonTaped(let entity))):
                    if let firstIndex = state.humanResult.firstIndex(of: entity) {
                        state.humanResult.remove(at: firstIndex)
                    }
                    return .cancel(id: CancelID.load)

                case .personListResponse(.success(let response)):
                    state.humanResult = response
                    return .none

                default:
                    return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
        .ifLet(\.$personDetail, action: /Action.personDetail) {
            PersonDetail()
        }
    }
}
