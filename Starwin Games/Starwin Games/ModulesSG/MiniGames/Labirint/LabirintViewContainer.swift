import SwiftUI
import SpriteKit


struct LabirintViewContainer: UIViewRepresentable {
    @StateObject var user = SGUser.shared
    var scene: MazeScene
    @Binding var isWin: Bool
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .clear
        scene.scaleMode = .resizeFill
        scene.isWinHandler = {
            isWin = true
            user.updateUserMoney(for: 100)
        }
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.frame = UIScreen.main.bounds
    }
}
