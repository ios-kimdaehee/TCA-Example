import ComposableArchitecture
import SwiftUI

@main
struct HumanRandomApp: App {
    var body: some Scene {
        WindowGroup {
            TopTabbarView(
                store: Store(
                    initialState: TopTabbar.State(),
                    reducer: { TopTabbar() }
                )
            )
        }
    }
}
