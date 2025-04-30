import SwiftUI

class AchievementsViewModelSG: ObservableObject {
    
    @Published var achievements: [AchievementSG] = [
        AchievementSG(image: "achi1IconSG", achievedCount: 0, achievedMaxCount: 1, isAchieved: false),
        AchievementSG(image: "achi2IconSG", achievedCount: 0, achievedMaxCount: 10, isAchieved: false),
        AchievementSG(image: "achi3IconSG", achievedCount: 0, achievedMaxCount: 1, isAchieved: false),
        AchievementSG(image: "achi4IconSG", achievedCount: 0, achievedMaxCount: 5, isAchieved: false)

    ] {
        didSet {
            saveAchievementsItem()
        }
    }
    
    init() {
        loadAchievementsItem()
        
    }
    
    private let userDefaultsAchievementsKey = "achievementsKeySG"
    
    func achieveToggle(_ achive: AchievementSG) {
        guard let index = achievements.firstIndex(where: { $0.id == achive.id })
        else {
            return
        }
        achievements[index].isAchieved.toggle()
        
    }
    
    func achieveCheck(_ achive: AchievementSG) {
        guard let index = achievements.firstIndex(where: { $0.image == achive.image })
        else {
            return
        }
        
        if achievements[index].achievedCount < achievements[index].achievedMaxCount {
            achievements[index].achievedCount += 1
        } else {
            achievements[index].isAchieved = true
        }
    }
    
    func saveAchievementsItem() {
        if let encodedData = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsAchievementsKey)
        }
        
    }
    
    func loadAchievementsItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsAchievementsKey),
           let loadedItem = try? JSONDecoder().decode([AchievementSG].self, from: savedData) {
            achievements = loadedItem
        } else {
            print("No saved data found")
        }
    }
}

struct AchievementSG: Codable, Hashable, Identifiable {
    var id = UUID()
    var image: String
    var achievedCount: Int
    var achievedMaxCount: Int
    var isAchieved: Bool
}
