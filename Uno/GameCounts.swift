//
//  GameCounts.swift
//  UnoUITests
//
//  Created by Eric Olson on 8/8/23.
//

import Foundation

struct GameCounts : CustomStringConvertible {
    var players: [Player:Int] = [:]
    
    var description: String {
        return "Game Counts: " + players.map({entry in "\(entry.key.name) won \(entry.value)"})
            .joined(separator: "; ")
    }
    
    mutating func countGame(game:Game) {
        guard let winner = game.winner else { fatalError("Cannot count game unless there is a winner") }
        players[winner] = (players[winner] ?? 0) + 1
    }
}
