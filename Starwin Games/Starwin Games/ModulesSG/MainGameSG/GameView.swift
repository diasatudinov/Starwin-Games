import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
   
    @State var gameScene: GameScene = {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    @ObservedObject var shopVM: StoreViewModelSG
    @ObservedObject var achievementVM: AchievementsViewModelSG
    @State private var powerUse = false
    @State private var isWin = false
    @State private var score = 0
    @State var level: Int
    var imagesForView: [String] = ["viewImage1","viewImage2","viewImage3","viewImage4","viewImage5", ""]
    var body: some View {
        ZStack {
            SpriteViewContainer(scene: gameScene, isWin: $isWin, score: $score, level: level)
                .ignoresSafeArea()
            
            VStack(spacing: SGDeviceManager.shared.deviceType == .pad ? 200:100) {
                HStack(spacing: SGDeviceManager.shared.deviceType == .pad ? 200:100) {
                    ZStack {
                        Image(.rectangleMainGame)
                            .resizable()
                            .scaledToFit()
                        
                        Image(imagesForView[Int.random(in: Range(0...imagesForView.count - 1))])
                            .resizable()
                            .scaledToFit()
                            .padding()
                            
                        
                    }
                    .frame(width: SGDeviceManager.shared.deviceType == .pad ? 280:140,height: SGDeviceManager.shared.deviceType == .pad ? 400:200)
                    
                    ZStack {
                        Image(.rectangleMainGame)
                            .resizable()
                            .scaledToFit()
                        
                        Image(imagesForView[Int.random(in: Range(0...imagesForView.count - 1))])
                            .resizable()
                            .scaledToFit()
                            .padding()
                            
                        
                    }
                    .frame(width: SGDeviceManager.shared.deviceType == .pad ? 280:140,height: SGDeviceManager.shared.deviceType == .pad ? 400:200)
                }
                
                HStack(spacing: SGDeviceManager.shared.deviceType == .pad ? 200:100) {
                    ZStack {
                        Image(.rectangleMainGame)
                            .resizable()
                            .scaledToFit()
                        
                        Image(imagesForView[Int.random(in: Range(0...imagesForView.count - 1))])
                            .resizable()
                            .scaledToFit()
                            .padding()
                            
                        
                    }
                    .frame(width: SGDeviceManager.shared.deviceType == .pad ? 280: 140,height: SGDeviceManager.shared.deviceType == .pad ? 400:200)
                    
                    ZStack {
                        Image(.rectangleMainGame)
                            .resizable()
                            .scaledToFit()
                        
                        Image(imagesForView[Int.random(in: Range(0...imagesForView.count - 1))])
                            .resizable()
                            .scaledToFit()
                            .padding()
                            
                        
                    }
                    .frame(width: SGDeviceManager.shared.deviceType == .pad ? 280:140,height: SGDeviceManager.shared.deviceType == .pad ? 400:200)
                }
            }
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                        Spacer()
                        ZStack {
                            Image(.scoreBgSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 200:100)
                            
                            Text("\(score)")
                                .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .bold))
                                .foregroundStyle(.yellow)
                                .offset(y: SGDeviceManager.shared.deviceType == .pad ? 60:30)
                        }
                        Spacer()
                        Button {
                            gameScene.restartLevel()
                            isWin = false
                        } label: {
                            Image(.restartBtnSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                    }.padding([.horizontal, .top])
                }
                
                Spacer()
            }
            
            if isWin {
                ZStack {
                    if let item = shopVM.currentBgItem {
                        Image(item.image)
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .scaledToFill()
                    }
                    VStack(spacing: SGDeviceManager.shared.deviceType == .pad ? -80:-40) {
                        Image(.winTextSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SGDeviceManager.shared.deviceType == .pad ? 800:400)
                        
                        Button {
                            gameScene.restartLevel()
                            isWin = false
                        } label: {
                            Image(.nextButtonSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 200:100)
                        }
                    }
                }
            }
            
        }.background(
            ZStack {
                if let item = shopVM.currentBgItem {
                    Image(item.image)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
            }
        )
        .onAppear {
            achievementVM.achieveCheck(AchievementSG(image: "achi1IconSG", achievedCount: 0, achievedMaxCount: 1, isAchieved: false))
        }
    }
}

#Preview {
    GameView(shopVM: StoreViewModelSG(), achievementVM: AchievementsViewModelSG(), level: 0)
}
