//
//  Game.swift
//  Uno
//
//  Created by Eric Olson on 8/7/23.
//

import Foundation

private let log = Logger(tag:#file).log

class Game {
    var players : [Player] = []
    var roundCounter = RoundCounts()

    func play() {
        
    }
    
    init() {
        for x in 1...2 {
            log("Round #\(x)")
            var round = Round(game: self)
            for name in ["Bluby","Henry","Rachel","Max"] {
                let player = Player(round: round, name:name)
                _ = player.drawCards(deck:round.drawDeck,count:7)
                _ = addPlayer(player: player)
            }
            round.play(turns: 1000)
            log("Round \(x) won by \(round.winner!).")
            roundCounter.countRound(round: round)
        }
    }
    
    func addPlayer(player: Player) -> Player {
        players.append(player)
        return player
    }
    
    var winner : Player? {
        players.first( where: {$0.hasWon()})
    }
    
    var gameOver : Bool {
        return winner != nil
    }
    
}
