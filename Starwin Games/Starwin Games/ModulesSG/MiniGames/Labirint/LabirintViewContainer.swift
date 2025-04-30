//
//  SpriteViewContainer.swift
//  Starwin Games
//
//  Created by Dias Atudinov on 30.04.2025.
//


import SwiftUI
import SpriteKit


struct LabirintViewContainer: UIViewRepresentable {
    @StateObject var user = GEUser.shared
    var scene: GameScene
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .clear
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.frame = UIScreen.main.bounds
    }
}
