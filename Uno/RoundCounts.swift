//
//  RoundCounts.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

struct RoundCounts : CustomStringConvertible {
    var players: [Player:Int] = [:]
    
    var description: String {
        return "Round Counts: " + players.map({entry in "\n\(entry.key.name) won \(entry.value)"})
            .joined(separator: " ")
    }
    
    mutating func countRound(round:Round) {
        players[round.winner!] = (players[round.winner!] ?? 0) + 1
    }
    
    mutating func addPlayer(_ player: Player) {
        players[player] = 0
    }
}
