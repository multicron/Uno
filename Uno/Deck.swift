//
//  Deck.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

private let log = Logger(tag:#file).log

class Deck : CustomStringConvertible {
    var cards: [Card] = []
    var description: String {
        return "Deck: \(cards.count) card(s) " +
        (cards.map {card in card.description}).joined(separator: ", ")
    }
    var discardDeck: Deck?
    var count: Int {
        return self.cards.count
    }
    
    func addDiscardDeck(deck: Deck) {
        self.discardDeck = deck
    }
    
    func addStandardDeck() {
        
        for _ in 1...4 {
            addCard(.wild(color:nil))
            addCard(.wildDraw4(color:nil))
        }
        
        Card.allColors.forEach { color in
            for _ in 1...2 {
                addCard(.draw2(color:color));
                addCard(.reverse(color:color));
                addCard(.skip(color:color));
            }
            
            Card.allNumbers.forEach{ number in
                if number==0 {
                    addCard(.number(color:color,number:number))
                }
                else {
                    addCard(.number(color:color,number:number))
                    addCard(.number(color:color,number:number))
                }
            }
        }
    }
    
    func addCard(_ card: Card) {
        self.cards.append(card)
    }
    
    func reshuffle() {
        log("Reshuffling")
        
        if let discardDeck {
            // Leave the top card on the discard deck,
            // shuffle the remainder of the discard deck,
            // replace the wild cards that now have colors set,
            // and replace this deck with the discardDeck
            
            let savedCard = discardDeck.cards.removeLast()
            discardDeck.shuffle()
            discardDeck.reinitializeWildCards()
            self.cards = discardDeck.cards
            discardDeck.cards = [savedCard]
        }
        else { log("No discard Deck to reshuffle")}
    }
    
    func reinitializeWildCards() {
        cards = cards.map { card in
            switch card {
            case .wild: return .wild(color:nil)
            case .wildDraw4: return .wildDraw4(color: nil)
            default: return card
            }
        }
    }
    
    func drawCard() -> Card {
        if (cards.isEmpty) {
            self.reshuffle()
        }
        return self.cards.removeFirst()
    }
    
    func shuffle() {
        return self.cards.shuffle()
    }
    
    func topCard() -> Card {
        return cards.last!
    }
}

