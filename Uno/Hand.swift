//
//  Hand.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

private let log = Logger(tag:#file).log

class Hand : Deck {
    override var description: String {
        return Hand.sortCards(cards).description
    }

    var isEmpty: Bool {self.cards.isEmpty}
    
    var score: Int { self.cards.reduce(0) {scoreAcc, card in scoreAcc + card.score} }
    
    func playableCards(on cardToPlayOn: Card) -> [Card] {
        var unsorted = self.cards.filter{ card in card.playable(on: cardToPlayOn)}
        
        let haveColorMatch = unsorted.filter({ card in card.color == cardToPlayOn.color}).count > 0
        
        if haveColorMatch {
            log("We have a color match and can't play Wild +4")
            unsorted = unsorted.filter { card in card.type != .wildPlus4}
        }
            
        return Hand.sortCards(unsorted)
    }
    
    static func compareCards(card0: Card, card1: Card) -> Bool {
        switch (card0.type,card1.type) {
        case (.number, .number):
            if let color0 = card0.color, let color1 = card1.color {
                if (color0 != color1) {
                    return color0.rawValue < color1.rawValue
                }
                else if let number0 = card0.number, let number1 = card1.number {
                    return number0 < number1
                }
            }
            return false
        case (.number, .plus2): return true
        case (.number, .reverse) : return true
        case (.number, .skip) : return true
        case (.number, .wild) : return true
        case (.number, .wildPlus4) : return true
        case (.skip, .reverse): return true
        case (.skip, .plus2): return true
        case (.skip, .wild): return true
        case (.skip, .wildPlus4): return true
        case (.reverse, .plus2): return true
        case (.reverse, .wild): return true
        case (.reverse, .wildPlus4): return true
        case (.plus2, .wild): return true
        case (.plus2, .wildPlus4): return true
        case (.wild, .wildPlus4): return true
        default: return false
        }
    }
    
    static func sortCards(_ cards: [Card]) -> [Card] {
        return cards.sorted(by: Self.compareCards)
    }

     func removeCard(_ cardToRemove: Card) -> Bool {
        if let index = self.cards.firstIndex(of: cardToRemove) {
            self.cards.remove(at: index)
            return true
        }
        else {
            return false
        }
    }
    
    func countColors() -> [Color:Int] {
        var colorCounts = Card.zeroedCardColorCounts

          self.cards.forEach { card in
            if let color = card.color {
                colorCounts[color]! += 1
            }
        }
        return colorCounts
    }
    
    func bestColor() -> Color? {
        
        guard let (maxColor, maxCount) = self.countColors().max(by: { item1, item2 in
            return item1.value < item2.value
        }) else {return nil}
        
        log("MaxCount \(maxCount), MaxColor \(maxColor)")
        if (maxCount > 0) {return maxColor}
        else {return nil}
    }
}

