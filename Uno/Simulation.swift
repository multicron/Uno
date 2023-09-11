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
        Task {
            let result = await sim.run()
            result.forEach {game in
                log("Game \(game.number) \(game.players.map {$0.name+" "+String($0.score)+";"})")
            }
        }
        dispatchMain()
    }
    
    mutating func addPlayer(_ player: Player) {
        players.append(player)
    }

    mutating func run() async -> [Game] {
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
                

        var result = [Game]()
        
        await withTaskGroup(of: Game.self) { group in
            
            for x in (1...1000) {
                let game = Game(number: x, winningScore: 500);
                
                
                game.addPlayer(Player(Strategy(.zingAlways)))
                game.addPlayer(Player(Strategy(.zingAlways)))
                game.addPlayer(Player(Strategy(.zingAlways)))
                game.addPlayer(Player(Strategy(.zingAlways)))
                
                //                    players.forEach {player in
                ////                        player.resetScore()
                ////                        game.addPlayer(player)
                //                    }
                
                group.addTask {
                    log("Game \(x)")
                    return await game.play()
                }
            }
            
            for await game in group {
                result.append(game)
            }
            
            print("Done with tasks")
        } // TaskGroup
        print(result.map {$0.winner})
        
        return result
        
    } // run
}
