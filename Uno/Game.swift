//
//  Game.swift
//  Uno
//
//  Created by Eric Olson on 8/7/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

struct Game {
    var roundCounter = RoundCounts()
    var players : [Player] = []
    var winningScore : Int
    var winner : Player? = nil
    
    mutating func play() {

        for name in ["Bluby","Henry","Rachel","Max"] {
            let player = Player(name: name)
            self.addPlayer(player)
        }

        for x in 1...1000 {
            log("--- Round #\(x) ---")
            
            var thisRound = Round()
            
            defer {
                log(roundCounter)
            }
            
            for player in players {
                let player = player
                thisRound.addPlayer(player)
                player.newHand()
                _ = player.drawCards(count:7)
                log("\(player.description)")
            }
                        
            thisRound.play(turns: 1000)
            
            guard let winner = thisRound.winner else {fatalError("Round ended with no winner")}
            
            log("Round \(x) won by \(winner.name) with a score of \(thisRound.score).")
            
            winner.addScore(thisRound.score)
            
            roundCounter.countRound(round: thisRound)
            
            if (winner.score >= winningScore) {
                self.winner = winner
                break
            }
        }
        guard let winner = self.winner else {fatalError("Game ended with no winner")}
        
        log("Game is over; \(winner.name) won with a score of \(winner.score)")

    }

    mutating func addPlayer(_ player: Player) {
        players.append(player)
    }
}
