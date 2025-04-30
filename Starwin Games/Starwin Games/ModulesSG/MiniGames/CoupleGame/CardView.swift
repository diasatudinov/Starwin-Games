import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                Image(card.type)
                    .resizable()
                    .scaledToFit()
                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 120:60)
            } else {
                Image(.cardBack)
                    .resizable()
                    .scaledToFit()
                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 120:60)
            }
        }
    }
}

#Preview {
    CardView(card: Card(type: "cardFace1"))
}