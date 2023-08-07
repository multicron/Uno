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
    static var gameCounter = GameCounts()

    static func main() {
        for x in (1...1000) {
            var game = Game();
            game.play(turns:1000);
            log("Game \(x) won by \(game.winner!).")
            gameCounter.countGame(game: game)
        }
        
        log(gameCounter)
    }
}
