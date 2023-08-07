//
//  GameHistory.swift
//  Uno
//
//  Created by Eric Olson on 8/3/23.
//

import Foundation

struct GameHistory : CustomStringConvertible {
    var plays: [(player: Player, hand: String, turn: TurnHistory)] = []
    
    var description: String {
        return plays
            .map {play in "\(play.player.name) \(play.turn) \(play.hand)"}
            .joined(separator: "\n")
    }
    
    mutating func recordTurn(player: Player, turn: TurnHistory) {
        plays.append((player,player.hand.description,turn))
    }
    
    
    
}
