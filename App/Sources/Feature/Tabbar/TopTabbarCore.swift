import ComposableArchitecture
import Dependencies

public struct TopTabbar: Reducer {

    public enum Action: Equatable, BindableAction {
        case onAppear
        case moveMaleTab(Person.Action)
        case moveFemaleTab(Person.Action)
        case binding(BindingAction<TopTabbar.State>)
    }

    public struct State: Equatable {
        public var male = Person.State()
        public var female = Person.State()
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.male, action: /Action.moveMaleTab) {
            Person(gender: .male)
        }

        Scope(state: \.female, action: /Action.moveFemaleTab) {
            Person(gender: .female)
        }
    }
}
