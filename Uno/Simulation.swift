//
//  Simulator.swift
//  Uno
//
//  Created by Eric Olson on 8/7/23.
//

import Foundation

fileprivate let log = Logger(tag:#file).log

@main

class Simulation {

    static func main() {
        for _ in (1...10) {
            let game = Game();
            game.play();
        }
    }
}
