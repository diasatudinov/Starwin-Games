import SwiftUI

class AchievementsViewModel: ObservableObject {
    
    @Published var achievements: [Achievement] = [
        Achievement(image: "achievementImage1", text: "First flight", subtitle: "start the first game", isAchieved: false),
        Achievement(image: "achievementImage2", text: "Sky veteran", subtitle: "play 20 matches", isAchieved: false),
        Achievement(image: "achievementImage3", text: "Strike Start", subtitle: "complete 5 levels without defeat", isAchieved: false),
        Achievement(image: "achievementImage4", text: "Bird in Color", subtitle: "buy first skin", isAchieved: false),
        Achievement(image: "achievementImage5", text: "Thunderstorm Slope", subtitle: "survive 3 thunderstorms in a row", isAchieved: false),
        Achievement(image: "achievementImage6", text: "Horizon Collector", subtitle: "buy a new background", isAchieved: false),
        Achievement(image: "achievementImage7", text: "Morning Session", subtitle: "log in 7 days in a row", isAchieved: false),
        Achievement(image: "achievementImage8", text: "Air Legend", subtitle: "get all other achievements", isAchieved: false),

    ] {
        didSet {
            saveAchievementsItem()
        }
    }
    
    init() {
        loadAchievementsItem()
        
    }
    
    private let userDefaultsAchievementsKey = "achievementsKey"
    
    func achieveToggle(_ achive: Achievement) {
        guard let index = achievements.firstIndex(where: { $0.id == achive.id })
        else {
            return
        }
        achievements[index].isAchieved.toggle()
        
    }
    
    func saveAchievementsItem() {
        if let encodedData = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsAchievementsKey)
        }
        
    }
    
    func loadAchievementsItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsAchievementsKey),
           let loadedItem = try? JSONDecoder().decode([Achievement].self, from: savedData) {
            achievements = loadedItem
        } else {
            print("No saved data found")
        }
    }
}

struct Achievement: Codable, Hashable, Identifiable {
    var id = UUID()
    var image: String
    var text: String
    var subtitle: String
    var isAchieved: Bool
}