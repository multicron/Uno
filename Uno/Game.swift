//
//  Game.swift
//  Uno
//
//  Created by Eric Olson on 8/7/23.
//

import Foundation

private let log = Logger(tag:#file).log

class Game {
    var roundCounter = RoundCounts()
    
    func play() {        

        for x in 1...3 {
            log("--- Round #\(x) ---")
            
            var thisRound = Round()
            
            for name in ["Bluby","Henry","Rachel","Max"] {
                let player = Player(round: thisRound, name: name)
                _ = thisRound.addPlayer(player)
                _ = player.drawCards(count:7)
                log("\(player.description)")
            }
                        
            thisRound.play(turns: 1000)
            
            log("Round \(x) won by \(thisRound.winner!) with a score of \(thisRound.score).")
            
            roundCounter.countRound(round: thisRound)
        }
        log(roundCounter)
    }
}
