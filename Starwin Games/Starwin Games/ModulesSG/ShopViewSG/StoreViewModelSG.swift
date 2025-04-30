import SwiftUI

enum StoreSection: Codable, Hashable {
    case backgrounds
    case skin
}

class StoreViewModelSG: ObservableObject {
    @Published var shopTeamItems: [Item] = [
        
        Item(name: "bg1", image: "gameBg1SG", icon: "backIcon1SG", section: .backgrounds, price: 100),
        Item(name: "bg2", image: "gameBg2SG", icon: "backIcon2SG", section: .backgrounds, price: 100),
        Item(name: "bg3", image: "gameBg3SG", icon: "backIcon3SG", section: .backgrounds, price: 100),
        Item(name: "bg4", image: "gameBg4SG", icon: "backIcon4SG", section: .backgrounds, price: 100),
        Item(name: "bg5", image: "gameBg5SG", icon: "backIcon5SG", section: .backgrounds, price: 100),
        
        
        Item(name: "skin1", image: "imageSkin1SG", icon: "iconSkin1SG", section: .skin, price: 100),
        Item(name: "skin2", image: "imageSkin2SG", icon: "iconSkin2SG", section: .skin, price: 100),
        Item(name: "skin3", image: "imageSkin3SG", icon: "iconSkin3SG", section: .skin, price: 100),
        Item(name: "skin4", image: "imageSkin4SG", icon: "iconSkin4SG", section: .skin, price: 100),
        Item(name: "skin5", image: "imageSkin5SG", icon: "iconSkin5SG", section: .skin, price: 100),
        Item(name: "skin6", image: "imageSkin6SG", icon: "iconSkin6SG", section: .skin, price: 100),
         
    ]
    
    @Published var boughtItems: [Item] = [
        Item(name: "bg1", image: "gameBg1SG", icon: "backIcon1SG", section: .backgrounds, price: 100),
        Item(name: "skin1", image: "imageSkin1SG", icon: "iconSkin1SG", section: .skin, price: 100),
    ] {
        didSet {
            saveBoughtItem()
        }
    }
    
    @Published var currentBgItem: Item? {
        didSet {
            saveCurrentBg()
        }
    }
    
    @Published var currentPersonItem: Item? {
        didSet {
            saveCurrentPerson()
        }
    }
    
    init() {
        loadCurrentBg()
        loadCurrentPerson()
        loadBoughtItem()
    }
    
    private let userDefaultsBgKey = "BgKeySG"
    private let userDefaultsPersonKey = "BirdKeySG"
    private let userDefaultsBoughtKey = "boughtItemsSG"

    
    func saveCurrentBg() {
        if let currentItem = currentBgItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsBgKey)
            }
        }
    }
    
    func loadCurrentBg() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBgKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentBgItem = loadedItem
        } else {
            currentBgItem = shopTeamItems[0]
            print("No saved data found")
        }
    }
    
    func saveCurrentPerson() {
        if let currentItem = currentPersonItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsPersonKey)
            }
        }
    }
    
    func loadCurrentPerson() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsPersonKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentPersonItem = loadedItem
        } else {
            currentPersonItem = shopTeamItems[8]
            print("No saved data found")
        }
    }
    
    func saveBoughtItem() {
        if let encodedData = try? JSONEncoder().encode(boughtItems) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsBoughtKey)
        }
        
    }
    
    func loadBoughtItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBoughtKey),
           let loadedItem = try? JSONDecoder().decode([Item].self, from: savedData) {
            boughtItems = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
}

struct Item: Codable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var icon: String
    var section: StoreSection
    var price: Int
}
