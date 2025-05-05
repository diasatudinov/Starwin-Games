import SwiftUI

struct NumberGuessGame: View {
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Game State
        @State private var target = Int.random(in: 100...999)
    @State private var guessDigits: [String] = []
    @State private var feedback: String = ""
    @State private var attempts = 0
    
    private let padNumbers = [1, 2, 3,
                              4, 5, 6,
                              7, 8, 9,
                              0]
    

        var body: some View {
            ZStack {
                VStack(spacing: SGDeviceManager.shared.deviceType == .pad ? 40:20) {
                    // Top bar
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

                    // Title
                    Image(.guessTheNumTextSG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 260:130)
                    // Input slots
                    HStack(spacing: 16) {
                        ForEach(0..<3) { idx in
                            ZStack {
                                Image(.numBgSG)
                                    .resizable()
                                    .scaledToFit()
                                    
                                Text( idx < guessDigits.count ? guessDigits[idx] : "" )
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            }.frame(width: SGDeviceManager.shared.deviceType == .pad ? 150:100, height: SGDeviceManager.shared.deviceType == .pad ? 150:100)
                        }
                    }
                    .padding(.vertical)


                    // Number Pad
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
                    LazyVGrid(columns: columns, spacing: SGDeviceManager.shared.deviceType == .pad ? 24:12) {
                        ForEach(padNumbers, id: \ .self) { num in
                            Button(action: { numberPressed(num) }) {
                                ZStack {
                                    Image(.keyBoardBtnSG)
                                        .resizable()
                                        .scaledToFit()
                                    Text("\(num)")
                                        .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 96:48, weight: .bold))
                                        .foregroundColor(.white)
                                }.frame(width: SGDeviceManager.shared.deviceType == .pad ? 150:100, height: SGDeviceManager.shared.deviceType == .pad ? 150:100)
                            }
                            .disabled(guessDigits.count >= 3)
                        }
                    }.frame(width: SGDeviceManager.shared.deviceType == .pad ? 500:350)
                    .padding(.horizontal)

                    Spacer()
                }
                
                if !feedback.isEmpty {
                    Text(feedback)
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                    
                    ZStack {
                        Image(.mazeViewBg)
                            .resizable()
                        
                        if Int(guessDigits.joined()) ?? 0 < target {
                            Image(.guessHigherSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 500:250)
                        } else if Int(guessDigits.joined()) ?? 0 > target{
                            Image(.guessLowerSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 500:250)
                        } else {
                            VStack(spacing: SGDeviceManager.shared.deviceType == .pad ? -80:-40) {
                                Image(.winTextSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 800:400)
                                
                                Button {
                                    resetGame()
                                } label: {
                                    Image(.nextButtonSG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: SGDeviceManager.shared.deviceType == .pad ? 200:100)
                                }
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

    // MARK: - Actions
    private func numberPressed(_ num: Int) {
        guard guessDigits.count < 3 else { return }
        guessDigits.append("\(num)")
        if guessDigits.count == 3 {
            evaluateGuess()
        }
    }

    private func evaluateGuess() {
        let guess = Int(guessDigits.joined()) ?? 0
        attempts += 1
        if guess < target {
            feedback = "Too low!"
        } else if guess > target {
            feedback = "Too high!"
        } else {
            feedback = "You got it in \(attempts) tries!"
            SGUser.shared.updateUserMoney(for: 100)
        }
        // Only reset if correct to allow victory state
        if feedback.starts(with: "You got it") {
            // Do nothing, user sees success
        } else {
            // Reset after delay for another attempt
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // clear digits but keep target and attempts
                guessDigits = []
                feedback = ""
            }
        }
    }

    private func resetGame() {
        target = Int.random(in: 100...999)
        guessDigits = []
        feedback = ""
        attempts = 0
    }
}

#Preview {
    NumberGuessGame()
}

struct NumberGuessGame1: View {
    // MARK: - Game State
    @State private var target = Int.random(in: 100...999)
    @State private var guessDigits: [String] = []
    @State private var feedback: String = ""
    @State private var attempts = 0

    // Background image name
    let backgroundImage = "space_background"
    // Home icon image name
    let homeIcon = "home_icon"

    // Number pad including 0
    private let padNumbers = [1, 2, 3,
                              4, 5, 6,
                              7, 8, 9,
                              0]

    var body: some View {
        ZStack {
            // Background
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Top bar
                HStack {
                    Button(action: { /* handle home action */ }) {
                        Image(homeIcon)
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Title
                Text("GUESS\nTHE NUMBER")
                    .font(.system(size: 48, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 4)

                // Input slots
                HStack(spacing: 16) {
                    ForEach(0..<3) { idx in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.white.opacity(0.8), lineWidth: 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.black.opacity(0.4))
                                )
                                .frame(width: 80, height: 80)
                            Text(idx < guessDigits.count ? guessDigits[idx] : "")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.vertical)

                // Feedback
                if !feedback.isEmpty {
                    Text(feedback)
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                }

                // Number Pad Grid
                let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(padNumbers, id: \.self) { num in
                        Button(action: { numberPressed(num) }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.7))
                                    .frame(height: 80)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                Text("\(num)")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .disabled(guessDigits.count >= 3)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
    }

    // MARK: - Actions
    private func numberPressed(_ num: Int) {
        guard guessDigits.count < 3 else { return }
        guessDigits.append("\(num)")
        if guessDigits.count == 3 {
            evaluateGuess()
        }
    }

    private func evaluateGuess() {
        let guess = Int(guessDigits.joined()) ?? 0
        attempts += 1
        if guess < target {
            feedback = "Too low!"
        } else if guess > target {
            feedback = "Too high!"
        } else {
            feedback = "You got it in \(attempts) tries!"
        }
        // Only reset if correct to allow victory state
        if feedback.starts(with: "You got it") {
            // Do nothing, user sees success
        } else {
            // Reset after delay for another attempt
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // clear digits but keep target and attempts
                guessDigits = []
                feedback = ""
            }
        }
    }

    private func resetGame() {
        target = Int.random(in: 100...999)
        guessDigits = []
        feedback = ""
        attempts = 0
    }
}
