import SwiftUI

struct ChooseLevelView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var shopVM: StoreViewModelSG
    @ObservedObject var achievementVM: AchievementsViewModelSG

    @State var openGame = false
    @State var selectedIndex = 0
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 150:75)
                        }
                        Spacer()
                        CoinBgSG()
                    }.padding([.horizontal, .top])
                }
                ScrollView {
                    HStack {
                        Spacer()
                    }
                    ForEach(Range(0...9)) { index in
                        ZStack {
                            Image(.planetLevel1)
                                .resizable()
                                .scaledToFit()
                                .frame(width: SGDeviceManager.shared.deviceType == .pad ? 200:100,height: SGDeviceManager.shared.deviceType == .pad ? 200:100)
                            
                            Text("\(index + 1)")
                                .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 80:40, weight: .bold))
                                .foregroundStyle(.black)
                        }.offset(x: CGFloat(Int.random(in: SGDeviceManager.shared.deviceType == .pad ? Range(-130...130):Range(-65...65))))
                            .onTapGesture {
                                selectedIndex = index
                                DispatchQueue.main.async {
                                    openGame = true
                                }
                                
                            }
                    }
                }
            }
        }.background(
            ZStack {
                Image(.shopBgSG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .fullScreenCover(isPresented: $openGame) {
            GameView(shopVM: shopVM, achievementVM: achievementVM, level: selectedIndex)
        }
    }
}

#Preview {
    ChooseLevelView(shopVM: StoreViewModelSG(), achievementVM: AchievementsViewModelSG())
}
