//
//  Simulator.swift
//  Uno
//
//  Created by Eric Olson on 8/7/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

@main

struct Simulation {
    var gameCounter : GameCounts = GameCounts()

    static func main() {
        var sim = Simulation()
        sim.run()
    }
    
    mutating func run() {
        for x in (1...1) {
            log("--- Simulation \(x) ---")
            var game = Game(winningScore: 1);
            game.play()
            gameCounter.countGame(game:game)
        }
        log(gameCounter)
    }
    
}
