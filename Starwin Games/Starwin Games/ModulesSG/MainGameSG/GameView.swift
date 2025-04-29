import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var gameScene: GameScene = {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    
    @State private var powerUse = false
    
    var body: some View {
        ZStack {
            SpriteViewContainer(scene: gameScene)
                .ignoresSafeArea()
            
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
//                        Button {
//                            gameScene.restartGame()
//                            
//                        } label: {
//                            Image(.restartIconAO)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 100:50)
//                        }
                        Spacer()
                        CoinBgSG()
                    }.padding([.horizontal, .top])
                }
                
                Spacer()
            }
            
        }
    }
}

#Preview {
    GameView()
}
