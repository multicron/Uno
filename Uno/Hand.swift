//
//  Hand.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

class Hand : Deck {
    override var description: String {
        return Hand.sortedCards(cards).description
    }

    var isEmpty: Bool { self.cards.isEmpty }
    
    var score: Int { self.cards.reduce(0) {accum, card in accum + card.score} }
    
    func playableCards(on cardToPlayOn: Card) -> [Card] {
        var unsorted = self.cards.filter{ card in card.playable(on: cardToPlayOn)}
        
        let haveColorMatch = unsorted.filter({ card in card.color == cardToPlayOn.color}).count > 0
        let haveWildDraw4 = unsorted.filter({ card in card == .wildDraw4(color: nil)}).count > 0

        if haveColorMatch && haveWildDraw4 {
            log("We have a color match and can't play Wild+4")
            unsorted = unsorted.filter {card in
                switch card {
                case .wildDraw4: return false
                default: return true
                }
            }
        }
        return Hand.sortedCards(unsorted)
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
    
    func countColors() -> [CardColor:Int] {
        var colorCounts = Card.zeroedCardColorCounts

          self.cards.forEach { card in
            if let color = card.color {
                colorCounts[color]! += 1
            }
        }
        return colorCounts
    }
    
    func bestColor() -> CardColor? {
        
        guard let (maxColor, maxCount) = self.countColors().max(by: { item1, item2 in
            return item1.value < item2.value
        }) else {return nil}
        
        log("MaxCount \(maxCount), MaxColor \(maxColor)")
        if (maxCount > 0) {return maxColor}
        else {return nil}
    }
}

