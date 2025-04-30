

import SwiftUI

struct MemorizationViewSG: View {
    @StateObject var user = GEUser.shared
    @Environment(\.presentationMode) var presentationMode

    // Names of the images in your Assets catalog
    let cardImages = ["card1SG", "card2SG", "card3SG", "card4SG", "card5SG", "card6SG", "card7SG", "card8SG"]
    let sequenceLength = 3
    
    // Game state
    @State private var sequence: [Int] = []
    @State private var currentStep: Int? = nil
    @State private var gamePhase: GamePhase = .showing
    @State private var userInputIndex = 0
    @State private var feedback: String? = nil
    
    enum GamePhase {
        case showing      // Showing sequence one by one full-screen
        case userTurn     // User repeats sequence
        case finished     // Game over
    }
    
    var body: some View {
        ZStack {
        VStack {
            HStack {
                VStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.homeIconSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 150:75)
                        }
                        Spacer()
                    }.padding([.horizontal, .top])
                    
                    Image(.memorizationTextSG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                }
            }
            
            Spacer()
            
            if gamePhase == .showing {
                // Full-screen reveal of each card in sequence
                if let idx = currentStep {
                    MemorizationCardView(imageName: cardImages[idx])
                        .frame(height: 300)
                        .padding()
                        .transition(.opacity)
                }
            } else {
                // Grid for user interaction
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    ForEach(0..<cardImages.count, id: \.self) { index in
                        MemorizationCardView(imageName: cardImages[index])
                            .onTapGesture {
                                handleTap(on: index)
                            }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            
        }
            
            if gamePhase == .finished {
                
                if userInputIndex >= sequenceLength {
                    ZStack {
                        Image(.mazeViewBg)
                            .resizable()
                        VStack(spacing: -40) {
                            Image(.winTextSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 400)
                            
                            Button {
                                startGame()
                            } label: {
                                Image(.nextButtonSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                        }
                    }
                } else {
                    ZStack {
                        Image(.mazeViewBg)
                            .resizable()
                        VStack(spacing: -40) {
                            Image(.loseTextSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                            
                            Button {
                                startGame()
                            } label: {
                                Image(.tryAgainIconSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                            }
                        }
                    }
                }
                
            }
    }
        .background(
            ZStack {
                Image(.mazeViewBg)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .onAppear {
            startGame()
        }
        .animation(.easeInOut, value: currentStep)
    }
    
    private var headerText: String {
        switch gamePhase {
        case .showing:
            return "Watch the sequence..."
        case .userTurn:
            return "Your turn: repeat the sequence"
        case .finished:
            return feedback ?? ""
        }
    }
    
    private func startGame() {
        sequence = Array(0..<cardImages.count).shuffled().prefix(sequenceLength).map { $0 }
        userInputIndex = 0
        feedback = nil
        gamePhase = .showing
        currentStep = nil
        
        Task {
            await revealSequence()
        }
    }
    
    @MainActor
    private func revealSequence() async {
        for idx in sequence {
            currentStep = idx
            try? await Task.sleep(nanoseconds: 800_000_000)
            currentStep = nil
            try? await Task.sleep(nanoseconds: 300_000_000)
        }
        gamePhase = .userTurn
    }
    
    private func handleTap(on index: Int) {
        guard gamePhase == .userTurn else { return }
        if index == sequence[userInputIndex] {
            userInputIndex += 1
            if userInputIndex >= sequenceLength {
                feedback = "Correct! You win!"
                user.updateUserMoney(for: 100)
                gamePhase = .finished
                
            }
        } else {
            feedback = "Wrong! Try again."
            gamePhase = .finished
        }
    }
}

struct MemorizationCardView: View {
    let imageName: String
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

#Preview {
    MemorizationViewSG()
}
