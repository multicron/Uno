//
//  RoundHistory.swift
//  Uno
//
//  Created by Eric Olson on 8/3/23.
//

import Foundation

struct RoundHistoryItem : CustomStringConvertible {
    var plays: [(player: Player, hand: String, turn: TurnHistoryItem)] = []
    
    var description: String {
        return plays.enumerated()
            .map {(offset,play) in
                "\(offset+1) \(play.player.name) \(play.turn) H:\(play.hand)"}
            .joined(separator: "\n")
    }
    
    mutating func recordTurn(player: Player, turn: TurnHistoryItem) {
        plays.append((player,player.hand.description,turn))
    }
    
    
    
}
