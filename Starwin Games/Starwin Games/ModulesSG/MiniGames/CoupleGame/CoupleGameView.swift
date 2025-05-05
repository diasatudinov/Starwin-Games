import SwiftUI
import AVFoundation

struct CoupleGameView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var user = SGUser.shared
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var cards: [Card] = []
    @State private var selectedCards: [Card] = []
    @State private var message: String = "Find all matching cards!"
    @State private var gameEnded: Bool = false
    @State private var isWin: Bool = false
    @State private var pauseShow: Bool = false
    private let cardTypes = ["cardFace1SG", "cardFace2SG", "cardFace3SG", "cardFace4SG", "cardFace5SG", "cardFace6SG"]
    private let gridSize = 4
    
    @State private var counter: Int = 0
    
    @State private var timeLeft: Int = 60
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            
                VStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.homeIconSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 160:80)
                        }
                        
                        Spacer()
                    }
                    
                    VStack(spacing: SGDeviceManager.shared.deviceType == .pad ? -40:-20) {
                        Image(.findCoupleText)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SGDeviceManager.shared.deviceType == .pad ? 240:120)
                        
                        ZStack {
                            Image(.coupleTimerBg)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 140:70)
                            
                            Text("\(timeLeft)")
                                .font(.system(size: SGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .bold))
                                .foregroundStyle(.yellow)
                        }
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        ForEach(cards) { card in
                            CardView(card: card)
                                .onTapGesture {
                                    flipCard(card)
                                   
                                }
                                .opacity(card.isMatched ? 0.5 : 1.0)
                        }
                        
                    }
                    .frame(width: SGDeviceManager.shared.deviceType == .pad ? 500:350)
                   
                }
                .onAppear {
                    setupGame()
                }
            
            if gameEnded {
                if isWin {
                    ZStack {
                        Image(.coupleGameBgSG)
                            .resizable()
                        VStack(spacing: -40) {
                            Image(.winTextSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 800:400)
                            
                            Button {
                                setupGame()
                            } label: {
                                Image(.nextButtonSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 200:100)
                            }
                        }
                    }
                } else {
                    ZStack {
                        Image(.coupleGameBgSG)
                            .resizable()
                        VStack(spacing: SGDeviceManager.shared.deviceType == .pad ? -80:-40) {
                            Image(.loseTextSG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SGDeviceManager.shared.deviceType == .pad ? 360:180)
                            
                            Button {
                                setupGame()
                            } label: {
                                Image(.tryAgainIconSG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SGDeviceManager.shared.deviceType == .pad ? 300:150)
                            }
                        }
                    }
                }
            }
           
            
        }
        .onReceive(timer) { _ in
            guard !gameEnded else { return }
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                gameEnded = true
                isWin = false
                timer.upstream.connect().cancel()
            }
        }
//        .onAppear {
//            startTimer()
//        }
        .background(
            Image(.coupleGameBgSG)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
        )
        
        
    }
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if counter < 4 {
                withAnimation {
                    counter += 1
                }
            }
        }
    }
    
    private func setupGame() {
        // Reset state
        selectedCards.removeAll()
        message = "Find all matching cards!"
        gameEnded = false
        timeLeft = 60
        // Restart timer
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        // Generate cards
        var gameCards = [Card]()
        
        // Add 4 cards of each type (24 cards total for 6 types)
        for type in cardTypes {
            gameCards.append(Card(type: type))
            gameCards.append(Card(type: type))
        }
                
        // Shuffle cards
        gameCards.shuffle()
        
        // Ensure exactly 25 cards
        cards = Array(gameCards.prefix(gridSize * gridSize))
    }
    
    private func flipCard(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }),
              !cards[index].isFaceUp,
              !cards[index].isMatched,
              selectedCards.count < 2 else { return }
        
        // Flip card
        cards[index].isFaceUp = true
        selectedCards.append(cards[index])
        
        if card.type == "cardSemaphore" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                resetAllCards()
            }
        } else if selectedCards.count == 2 {
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        let allMatch = selectedCards.allSatisfy { $0.type == selectedCards.first?.type }
        
        if allMatch {
            for card in selectedCards {
                if let index = cards.firstIndex(where: { $0.id == card.id }) {
                    cards[index].isMatched = true
                }
            }
            message = "You found a match! Keep going!"
            isWin = true
        } else {
            message = "Not a match. Try again!"
            isWin = false
        }
        
        // Flip cards back over after a delay if they don't match
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for card in selectedCards {
                if let index = cards.firstIndex(where: { $0.id == card.id }) {
                    cards[index].isFaceUp = false
                }
            }
            selectedCards.removeAll()
            
            // Check if all cards are matched
            if cards.allSatisfy({ $0.isMatched || $0.type == "cardSemaphore" }) {
                message = "Game Over! You found all matches!"
                gameEnded = true
                user.updateUserMoney(for: 100)
            }
        }
    }
    
    private func resetAllCards() {
        message = "Red semaphore! All cards reset!"
        for index in cards.indices {
            cards[index].isFaceUp = false
            
            cards[index].isMatched = false
            
        }
        selectedCards.removeAll()
    }
    
}

#Preview {
    CoupleGameView()
}
