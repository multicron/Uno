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

        self.addPlayer(Player("Naive 1", Strategy(.playRandomCard)))
        self.addPlayer(Player("Naive 2", Strategy(.zingAlways)))
        self.addPlayer(Player("Naive 2", Strategy(.followNumber)))
        self.addPlayer(Player("Naive 2", Strategy(.followColor,.followNumber)))

//        self.addPlayer(Player("Naive 3", Strategy(.followColor)))
//        self.addPlayer(Player("Naive 4", Strategy(.followColor)))
//                self.addPlayer(Player("zingAlways 1", Strategy(.zingAlways)))
//        self.addPlayer(Player("zingOnOneCard", Strategy(.zingOnOneCard)))
//        self.addPlayer(Player("zingAlways 2", Strategy(.zingAlways)))
//        self.addPlayer(Player("zingOnAnyoneOneCard", Strategy(.zingOnAnyoneOneCard)))
//        self.addPlayer(Player("zingOnAnyoneTwoCards", Strategy(.zingOnAnyoneTwoCards)))
//        self.addPlayer(Player("Naive 5", Strategy(.followColor)))
//        self.addPlayer(Player("zingOnOneCard", Strategy(.followColor,.zingOnOneCard)))
//        self.addPlayer(Player("zingOnTwoCards", Strategy(.followColor,.zingOnTwoCards)))
//        self.addPlayer(Player("zingAlways", Strategy(.followColor,.zingAlways)))
        
        for x in 1...1000 {
            log("--- Round #\(x) ---")
            
            var thisRound = Round()
            
            defer {
                log(roundCounter)
            }
            
            for player in players {
                thisRound.addPlayer(player)
                player.newHand()
                _ = player.drawCards(count:7)
                log("\(player.description)")
            }
            
            thisRound.chooseRandomStartingPlayer()
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
