//
//  Game.swift
//  Uno
//
//  Created by Eric Olson on 8/7/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

class Game {
    var number: Int
    var winningScore : Int

    var roundCounter = RoundCounts()
    var players : [Player] = []
    var winner : Player? = nil
    
    init(number: Int, winningScore: Int) {
        self.number = number
        self.winningScore = winningScore
    }
    
    func play() async -> Game {
        
        for x in 1...1000 {
            log("--- Round #\(x) ---")
            let roundWinner = playOneRound(x)
            
            let gameWinners = players.filter {$0.score >= self.winningScore}
                        
            if gameWinners.count == 1 {
                let winner =  gameWinners[0]
                log("Game ended after \(x) rounds; \(winner.name) won with a score of \(winner.score)")
                self.winner = winner
                return self
            }
            
         }
        fatalError("Game lasted for 1000 rounds")
    }
    
    func playOneRound(_ x: Int) -> Player {
        
        let thisRound = Round()
        
        defer {
            log(roundCounter)
        }
        
        for var player in players {
            thisRound.addPlayer(player)
            player.newHand()
            _ = player.drawCards(count:7)
            log("\(player.description)")
        }
        
        thisRound.chooseRandomStartingPlayer()
        thisRound.play(turns: 1000)
        
        guard let roundWinner = thisRound.winner else {fatalError("Round ended with no winner")}
        
        log("Round \(x) won by \(roundWinner.name) with a score of \(thisRound.score).")
        
        roundWinner.addScore(thisRound.score)
        
        roundCounter.countRound(round: thisRound)
        
        return roundWinner
    }
        
     func addPlayer(_ player: Player) {
        players.append(player)
    }
}
