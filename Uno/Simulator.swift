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

    static func main() {
        for x in (1...10) {
            let game = Game();
            game.play();
        }
    }
}
