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
    var currentRound : Round?
    
    func play() {
        for x in 1...3 {
            log("--- Round #\(x) ---")
            currentRound = Round(game: self)
            players = [];
            for name in ["Bluby","Henry","Rachel","Max"] {
                let player = Player(game: self, name:name)
                _ = player.drawCards(deck:currentRound!.drawDeck,count:7)
                _ = addPlayer(player: player)
            }
            players.forEach {log("\($0.description)")}
            if var round = currentRound {
                round.play(turns: 1000)
            }
            log("Round \(x) won by \(currentRound!.winner!).")
            roundCounter.countRound(round: currentRound!)
        }
        log(roundCounter)

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
