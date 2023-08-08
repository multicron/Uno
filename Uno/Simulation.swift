//
//  Simulator.swift
//  Uno
//
//  Created by Eric Olson on 8/7/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

@main

class Simulation {

    static func main() {
        for x in (1...10) {
            log("--- Simulation \(x) ---")
            let game = Game();
            game.play();
        }
    }
}
