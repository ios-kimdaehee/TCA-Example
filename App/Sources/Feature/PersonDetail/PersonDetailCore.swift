import ComposableArchitecture
import SwiftUI
import Core

public struct PersonDetail: Reducer {
    public var pictureURL: URL?
    @Dependency(\.isPresented) var isPresented

    public enum Action: Equatable {
        case onAppear
    }

    public struct State: Equatable {
        var pictureURL: URL?
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            case .onAppear:
                state.pictureURL = self.pictureURL
                return .none
        }
    }
}
