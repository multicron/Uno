//
//  Play.swift
//  Uno
//
//  Created by Eric Olson on 8/3/23.
//

import Foundation

struct TurnHistory : CustomStringConvertible {
    var cardPlayed : Card?
    var skipped: Bool = false
    var cardsDrawn : [Card] = []
    
    var description: String {
        switch true {
        case cardPlayed != nil && cardsDrawn.count == 1: return "Drew & Played \(cardsDrawn)"
        case cardPlayed != nil: return "Played \([cardPlayed!])"
        case skipped: return "Skipped"
        case cardsDrawn.count > 0: return "Drew \(cardsDrawn.count) \(cardsDrawn)"
        default: return self.description
        }
    }
}
