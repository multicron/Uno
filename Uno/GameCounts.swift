//
//  GameCounts.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

struct GameCounts : CustomStringConvertible {
    var players: [Player:Int] = [:]
    
    var description: String {
        return "Game Counts: " + players.map({entry in "\n\(entry.key.name) won \(entry.value)"})
            .joined(separator: " ")
    }
    
    mutating func countGame(game:Game) {
        players[game.winner!] = (players[game.winner!] ?? 0) + 1
    }
    
    mutating func addPlayer(_ player: Player) {
        players[player] = 0
    }
}
