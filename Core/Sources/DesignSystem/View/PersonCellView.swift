import SwiftUI

public struct PersonCellView: View {
    let entity: HumanResultEntity
    var action: () -> Void

    public init(
        entity: HumanResultEntity,
        action: @escaping () -> Void = {}
    ) {
        self.entity = entity
        self.action = action
    }

    public var body: some View {
        HStack {
            Button(action: action) {
                AsyncImage(
                    url: entity.picture,
                    content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Rectangle())
                            .ignoresSafeArea()
                            .cornerRadius(10)
                    },
                    placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                )
            }

            VStack(alignment: .leading) {
                Text(entity.name)
                    .font(.system(size: 18, weight: .bold, design: .serif))

                Text(entity.location)
                    .font(.system(size: 16, weight: .medium, design: .default))

                Text(entity.cell)
                    .font(.system(size: 14, weight: .regular, design: .default))
            }
            .padding(.leading, 10)
        }
    }
}
