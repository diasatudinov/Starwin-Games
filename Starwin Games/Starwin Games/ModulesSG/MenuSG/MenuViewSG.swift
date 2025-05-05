import SwiftUI

struct MenuViewSG: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showAchievement = false
    @State private var showMiniGames = false
    @State private var showSettings = false
    
    @StateObject var achievementVM = AchievementsViewModelSG()
    @StateObject var settingsVM = SettingsViewModelSG()
    @StateObject var shopVM = StoreViewModelSG()
    
    var body: some View {
        
        ZStack {
            
            Image(.logoSG)
                .resizable()
                .scaledToFit()
                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 300:150)
                .padding(.bottom, SGDeviceManager.shared.deviceType == .pad ? 440:220)
            
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    CoinBgSG()
                    
                    Spacer()
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image(.settingsIconSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SGDeviceManager.shared.deviceType == .pad ? 140:70)
                    }
                }
                
                
                Spacer()
                Button {
                    showGame = true
                } label: {
                    Image(.playIconSG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 240:180)
                        .padding(.top, SGDeviceManager.shared.deviceType == .pad ? 180:90)
                }
                
                Spacer()
                ZStack {
                    HStack {
                        Button {
                            showMiniGames = true
                        } label: {
                            Image(.miniGamesIconSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 140:90)
                        }
                    }
                    
                    HStack(alignment: .bottom) {
                        
                        Button {
                            showShop = true
                        } label: {
                            Image(.shopIconSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 140:70)
                        }
                        Spacer()
                        
                        Button {
                            showAchievement = true
                        } label: {
                            Image(.achivsIconSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 140:70)
                        }
                    }
                }
            }.padding()
                .ignoresSafeArea(edges: .bottom)
            
        }
        .background(
            ZStack {
                Image(.menuBgSG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
//                    .onAppear {
//                        if settingsVM.musicEnabled {
//                            GEMusicManager.shared.playBackgroundMusic()
//                        }
//                    }
//                    .onChange(of: settingsVM.musicEnabled) { enabled in
//                        if enabled {
//                            GEMusicManager.shared.playBackgroundMusic()
//                        } else {
//                            GEMusicManager.shared.stopBackgroundMusic()
//                        }
//                    }
        .fullScreenCover(isPresented: $showGame) {
            ChooseLevelView(shopVM: shopVM, achievementVM: achievementVM)
        }
        .fullScreenCover(isPresented: $showMiniGames) {
            MiniGamesChooseView()
        }
        .fullScreenCover(isPresented: $showAchievement) {
            AchievementsViewSG(viewModel: achievementVM)
        }
        .fullScreenCover(isPresented: $showShop) {
            ShopViewSG(viewModel: shopVM)
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsViewSG(settingsVM: settingsVM)
        }
        
        
        
        
    }
    
}

#Preview {
    MenuViewSG()
}
