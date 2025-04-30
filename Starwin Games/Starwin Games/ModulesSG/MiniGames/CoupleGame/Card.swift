//
//  Card.swift
//  Starwin Games
//
//  Created by Dias Atudinov on 30.04.2025.
//


import Foundation

struct Card: Identifiable {
    let id = UUID()
    let type: String
    var isFaceUp = false
    var isMatched = false
}