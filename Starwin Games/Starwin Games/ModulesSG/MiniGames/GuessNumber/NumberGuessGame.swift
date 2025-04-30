import SwiftUI

struct NumberGuessGame: View {
    // Generate a random 3-digit number (100-999)
    @State private var target = Int.random(in: 100...999)
    @State private var guessText = ""
    @State private var feedback = "Enter your 3-digit guess"
    @State private var attempts = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Guess the 3-Digit Number")
                .font(.largeTitle)
                .bold()

            Text(feedback)
                .font(.title2)
                .foregroundColor(.blue)

            TextField("e.g. 123", text: $guessText)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150)

            Button("Submit Guess") {
                submitGuess()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isValidInput)

            Text("Attempts: \(attempts)")
                .font(.subheadline)

            if feedback == "Correct!" {
                Button("Play Again") {
                    resetGame()
                }
                .padding(.top)
            }
        }
        .padding()
    }

    private var isValidInput: Bool {
        // Check for exactly 3 digits
        guessText.count == 3 && Int(guessText) != nil
    }

    private func submitGuess() {
        guard let guess = Int(guessText) else { return }
        attempts += 1
        if guess < target {
            feedback = "Too low!"
        } else if guess > target {
            feedback = "Too high!"
        } else {
            feedback = "Correct!"
        }
    }

    private func resetGame() {
        target = Int.random(in: 100...999)
        guessText = ""
        feedback = "Enter your 3-digit guess"
        attempts = 0
    }
}
