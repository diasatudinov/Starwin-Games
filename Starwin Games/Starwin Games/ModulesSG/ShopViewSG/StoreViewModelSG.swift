//
//  StoreSection.swift
//  Starwin Games
//
//  Created by Dias Atudinov on 24.04.2025.
//


import SwiftUI

enum StoreSection: Codable, Hashable {
    case backgrounds
    case bird
}

class StoreViewModelSG: ObservableObject {
    @Published var shopTeamItems: [Item] = [
        
        Item(name: "bg1", image: "gameBg1AO", icon: "iconBg1AO", section: .backgrounds, price: 100),
        Item(name: "bg2", image: "gameBg2AO", icon: "iconBg2AO", section: .backgrounds, price: 100),
        Item(name: "bg3", image: "gameBg3AO", icon: "iconBg3AO", section: .backgrounds, price: 100),
        
        
        Item(name: "bird1", image: "gameBg3GE", icon: "iconBird1AO", section: .bird, price: 100),
        Item(name: "bird2", image: "gameBg3GE", icon: "iconBird2AO", section: .bird, price: 100),
        Item(name: "bird3", image: "gameBg3GE", icon: "iconBird3AO", section: .bird, price: 100),
        Item(name: "bird4", image: "gameBg3GE", icon: "iconBird4AO", section: .bird, price: 100),
         
    ]
    
    @Published var boughtItems: [Item] = [
        Item(name: "bg1", image: "gameBg1GE", icon: "icon1GE", section: .backgrounds, price: 500),
        Item(name: "bird1", image: "gameBg3GE", icon: "iconBird1AO", section: .bird, price: 500),
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
    
    private let userDefaultsBgKey = "BgKey"
    private let userDefaultsPersonKey = "BirdKey"
    private let userDefaultsBoughtKey = "boughtItems"

    
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
            currentPersonItem = shopTeamItems[3]
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
