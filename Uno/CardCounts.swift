//
//  CardCounts.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

struct CardCounts : CustomStringConvertible {
    var colors: [Color:Int] = Card.zeroedCardColorCounts
    var players: [Player] = []
    
    var description: String {
        return "Color Counts: " + colors.map({entry in "\(entry.key):\(entry.value)"})
            .joined(separator: " ")
    }
    
    mutating func countCard(card:Card) {
        if let color = card.color {
                self.colors[color]? += 1
        }
    }
    
    mutating func addPlayer(_ player: Player) {
        players.append(player)
    }
}
