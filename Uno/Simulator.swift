//
//  Simulator.swift
//  Uno
//
//  Created by Eric Olson on 8/7/23.
//

import Foundation

private let log = Logger(tag:#file).log

@main

class Simulator {
    static var roundCounter = RoundCounts()

    static func main() {
        for x in (1...1000) {
            var round = Round();
            round.play(turns:1000);
            log("Round \(x) won by \(round.winner!).")
            roundCounter.countRound(round: round)
        }
        
        log(roundCounter)
    }
}
