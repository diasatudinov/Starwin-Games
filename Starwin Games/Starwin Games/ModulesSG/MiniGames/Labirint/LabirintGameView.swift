import SwiftUI
import SpriteKit

struct LabirintGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isWin = false
    @State private var gameScene: MazeScene = {
        let scene = MazeScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    
    @State private var powerUse = false
    
    var body: some View {
        ZStack {
            LabirintViewContainer(scene: gameScene, isWin: $isWin)
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
                        Spacer()
                        Image(.maizeTextSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                        Spacer()

                    }.padding([.horizontal, .top])
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Button {
                        gameScene.moveUp()
                        
                    } label: {
                        Image(.controlArrowSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    }
                    HStack(spacing: 50) {
                        Button {
                            gameScene.moveLeft()
                        } label: {
                            Image(.controlArrowSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .rotationEffect(.degrees(90))
                                .scaleEffect(x: -1, y: 1)
                        }
                        
                        Button {
                            gameScene.moveRight()
                        } label: {
                            Image(.controlArrowSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .rotationEffect(.degrees(90))
                        }
                    }
                    
                    Button {
                        gameScene.moveDown()
                    } label: {
                        Image(.controlArrowSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .scaleEffect(x: 1, y: -1)
                    }
                }
                
            }
            
            if isWin {
                ZStack {
                    Image(.mazeViewBg)
                        .resizable()
                    VStack(spacing: -40) {
                        Image(.winTextSG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 400)
                        
                        Button {
                            gameScene.restartGame()
                            isWin = false
                        } label: {
                            Image(.nextButtonSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        }
                    }
                }
            }
            
        }.background(
            ZStack {
                Image(.mazeViewBg)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
    }
}

#Preview {
    LabirintGameView()
}
