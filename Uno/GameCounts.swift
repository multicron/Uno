//
//  GameCounts.swift
//  UnoUITests
//
//  Created by Eric Olson on 8/8/23.
//

import Foundation

struct GameCounts : CustomStringConvertible {
    var players: [Player:Int] = [:]
    
    var totalGames: Int { return players.reduce(0){accum, entry in return accum+entry.value}}
    var description: String {
        let sorted = players.sorted {$0.value >= $1.value}
        return "Game Stats \(totalGames): " + sorted.map({entry in "\(entry.key.name) won \(String(format:"%.1f",100.0*Float(entry.value)/Float(totalGames)))%"})
            .joined(separator: "; ")
    }
    
    mutating func countGame(game:Game) {
        guard let winner = game.winner else { fatalError("Cannot count game unless there is a winner") }
        players[winner] = (players[winner] ?? 0) + 1
    }
}
