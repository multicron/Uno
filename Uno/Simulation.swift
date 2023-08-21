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
    var players : [Player] = []

    static func main() {
        var sim = Simulation()
        sim.run()
    }
    
    mutating func addPlayer(_ player: Player) {
        players.append(player)
    }

    mutating func run() {
        self.addPlayer(Player(Strategy(.followColor)))
        self.addPlayer(Player(Strategy(.followColor)))
        self.addPlayer(Player(Strategy(.followColor)))
        self.addPlayer(Player(Strategy(.followColor)))

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
        
        for x in (1...40000) {
//            log("--- Game \(x) ---")
            var game = Game(winningScore: 500);
            players.forEach {player in
                player.resetScore()
                game.addPlayer(player)
            }
            game.play()
            gameCounter.countGame(game:game)
            log(gameCounter)
        }
//        log(gameCounter)
    }
    
}
