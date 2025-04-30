

import SwiftUI

struct MemorizationViewSG: View {
    // Names of the images in your Assets catalog
    let cardImages = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8"]
    let sequenceLength = 3

    // Game state
    @State private var sequence: [Int] = []
    @State private var currentHighlightIndex: Int? = nil
    @State private var gamePhase: GamePhase = .showing
    @State private var userInputIndex = 0
    @State private var feedback: String? = nil

    enum GamePhase {
        case showing  // Showing the sequence
        case userTurn // Waiting for user input
        case finished // Game over (win/lose)
    }

    var body: some View {
        VStack {
            // Header text
            Text(feedbackMessage)
                .font(.title2)
                .padding()

            // Grid of cards
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(0..<cardImages.count, id: \.self) { index in
                    CardView(
                        imageName: cardImages[index],
                        isHighlighted: index == currentHighlightIndex
                    )
                    .onTapGesture {
                        handleTap(on: index)
                    }
                }
            }
            .padding()

            // Play Again button
            if gamePhase == .finished {
                Button("Play Again") {
                    startGame()
                }
                .padding(.top)
            }
        }
        .onAppear {
            startGame()
        }
    }

    // Computed header message
    private var feedbackMessage: String {
        switch gamePhase {
        case .showing:
            return "Watch the sequence..."
        case .userTurn:
            return "Your turn: repeat the sequence"
        case .finished:
            return feedback ?? ""
        }
    }

    // Initialize and begin showing a new sequence
    private func startGame() {
        sequence = Array(0..<cardImages.count).shuffled().prefix(sequenceLength).map { $0 }
        userInputIndex = 0
        feedback = nil
        gamePhase = .showing

        Task {
            await showSequence()
        }
    }

    // Handle taps only during user phase
    private func handleTap(on index: Int) {
        guard gamePhase == .userTurn else { return }

        if index == sequence[userInputIndex] {
            userInputIndex += 1
            if userInputIndex >= sequenceLength {
                feedback = "Correct! You win!"
                gamePhase = .finished
            }
        } else {
            feedback = "Wrong! Try again."
            gamePhase = .finished
        }
    }

    // Asynchronously flash the sequence
    @MainActor
    private func showSequence() async {
        for idx in sequence {
            currentHighlightIndex = idx
            try? await Task.sleep(nanoseconds: 800_000_000) // 0.8s
            currentHighlightIndex = nil
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
        }
        gamePhase = .userTurn
    }
}

// Single card view with optional highlight
struct CardView: View {
    let imageName: String
    let isHighlighted: Bool

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isHighlighted ? Color.blue : Color.clear, lineWidth: 4)
            )
            .cornerRadius(8)
    }
}

#Preview {
    LabirintGameView()
}
