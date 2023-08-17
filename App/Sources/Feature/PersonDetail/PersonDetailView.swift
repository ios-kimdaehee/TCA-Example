import ComposableArchitecture
import SwiftUI
import Core

public struct PersonDetailView: View {
    private let store: StoreOf<PersonDetail>
    @Environment(\.presentationMode) var presentationMode

    public init(store: StoreOf<PersonDetail>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                AsyncImage(
                    url: viewStore.pictureURL,
                    content:  { image in
                        GeometryReader { proxy in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width, height: proxy.size.width)
                                .clipShape(Rectangle())
                                .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.width)))
                                .ignoresSafeArea()
                        }
                    },
                    placeholder: {
                        ProgressView()
                    }
                )

                VStack {
                    HStack {
                        Spacer()
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "multiply")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 16)
                        }
                    }
                    .padding(.top, 16)
                    Spacer()
                }
            }
        }
        .background { Color.black.ignoresSafeArea() }
    }
}
