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
        self.addPlayer(Player(Strategy(.followNumber)))
        self.addPlayer(Player(Strategy(.followColor)))
        self.addPlayer(Player(Strategy(.followNumber)))
        
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
        
        Task {
            await withTaskGroup(of: Game.self) { group in
                var result = [Game]()
                
                for x in (1...1000) {
                    let game = Game(number: x, winningScore: 500);
                    
                    
                    game.addPlayer(Player(Strategy(.followNumber)))
                    game.addPlayer(Player(Strategy(.followNumber)))
                    game.addPlayer(Player(Strategy(.followNumber)))
                    game.addPlayer(Player(Strategy(.followNumber)))
                    
                    //                    players.forEach {player in
                    ////                        player.resetScore()
                    ////                        game.addPlayer(player)
                    //                    }
                    
                    group.addTask {
//                        sleep(UInt32.random(in:0...5))
                        return await game.play()
                    }
                }
                
                for await game in group {
                    print("Game \(game.number) \(game.players.map {$0.name+" "+String($0.score)+";"})")
                    result.append(game)
                }
                
            }
        }
        sleep(1000000)
    }
    
    func runOneGame(_ game: Game) async -> Player {
        //            log(game)
        _ = await game.play()
        //                gameCounter.countGame(game:game)
        //                log(gameCounter)
        //            log(game)
        return game.winner!
        
    }
    
}
