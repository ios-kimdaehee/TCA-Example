import ComposableArchitecture
import SwiftUI
import Core

public struct PersonView: View {
    @State private var isPresented = false

    private var pictureURL: URL?
    private let store: StoreOf<Person>

    let columns = [GridItem.init(.flexible(), spacing: 16, alignment: .top), GridItem.init(.flexible(), alignment: .top)]
    public init(store: StoreOf<Person>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Menu {
                        Button("1단", action: { viewStore.send(.tapIsCellButton("1단")) })
                        Button("2단", action: { viewStore.send(.tapIsCellButton("2단"))})
                    } label: {
                        Text(viewStore.isCell)
                            .font(.title3)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.blue, lineWidth: 1)
                            )
                    }
                    .padding(.leading, 20)
                    .padding(.vertical, 5)
                    Spacer()
                }
                if viewStore.isCell == "1단" {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewStore.humanResult, id: \.self) { result in
                                PersonCellView(entity: result) {
                                    viewStore.send(.setDetailPicture(pictureURL: result.picture))
                                }
                                .onTapGesture {}
                                .onLongPressGesture { viewStore.send(.longTapCell(result)) }
                            }
                            .refreshable {
                                viewStore.send(.onAppear)
                            }
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewStore.humanResult) { result in
                                PersonGridView(entity: result) {
                                    viewStore.send(.setDetailPicture(pictureURL: result.picture))
                                }
                                .onTapGesture {}
                                .onLongPressGesture { viewStore.send(.longTapCell(result)) }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .refreshable {
                        viewStore.send(.onAppear)
                    }
                }
            }
            .alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
            .fullScreenCover(
                store: store.scope(state: \.$personDetail, action: Person.Action.personDetail),
                content: PersonDetailView.init(store: )
            )
            .task {
                viewStore.send(.onAppear)
            }
        }
    }
}
