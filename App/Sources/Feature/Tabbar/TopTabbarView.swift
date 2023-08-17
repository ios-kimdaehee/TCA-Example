import ComposableArchitecture
import SwiftUI

public struct TopTabbarView: View {
    private let store: StoreOf<TopTabbar>
    private let cooridnateSpaceName = "scrollview"

    @State private var tabBarSelection: CGFloat = 0
    @State private var tabViewSelection: Int = 0
    @State private var isAnimatingForTap: Bool = false

    public init(store: StoreOf<TopTabbar>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                SlidingTabBar(
                    selection: $tabBarSelection,
                    tabs: ["남자", "여자"]
                ) { newValue in
                    isAnimatingForTap = true
                    tabViewSelection = newValue
                    DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(300))) {
                        isAnimatingForTap = false
                    }
                }

                TabView(selection: $tabViewSelection) {
                    PersonView(store: self.store.scope(state: \.male, action: TopTabbar.Action.moveMaleTab))
                        .tag(0)
                        .readFrame(in: .named(cooridnateSpaceName)) { frame in
                            guard !isAnimatingForTap else { return }
                            tabBarSelection = (-frame.origin.x / frame.width)
                        }

                    PersonView(store: self.store.scope(state: \.female, action: TopTabbar.Action.moveFemaleTab))
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .coordinateSpace(name: cooridnateSpaceName)
                .animation(.linear(duration: 0.2), value: tabViewSelection)
            }
            .task {
                await viewStore
                    .send(.onAppear)
                    .finish()
            }
        }
    }
}
