//
//  Player.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

private let log = Logger(tag:#file).log

struct Player : CustomStringConvertible, Hashable {
    let round: Round
    let name: String
    private let score: Int = 0
    var hand: Hand = Hand()
    var description: String {
        return "Player Name: \(name) Score: \(score) Hand: \(hand.description)"
    }
    
    init(round: Round, name: String) {
        self.round = round
        self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func ==(player1:Player, player2:Player) -> Bool {
        return player1.name == player2.name
    }
    
    func hasWon() -> Bool {
        return self.hand.isEmpty
    }
    
    func drawCards(deck: Deck, count: Int = 1) -> [Card] {
        var drawn : [Card] = []
        for _ in 1...count {
            let card = deck.drawCard()
            drawn.append(card)
            hand.addCard(card)
        }
        return drawn
    }
    
    func playCard(card: Card) {
        var cardToPlay = card
        
        let _ = hand.removeCard(card)
        
        if cardToPlay.type == .wild || cardToPlay.type == .wildPlus4 {
            if let bestColor = self.hand.bestColor() {
                cardToPlay.color = bestColor;
            }
            else {
                cardToPlay.color = Color.red
            }
        }
        
        round.discardDeck.addCard(cardToPlay)
    }
    
    func playOneTurn(turnIsSkipped: Bool, penaltiesToDraw: Int) -> TurnHistory {
        
        var turn = TurnHistory()
        
        log("\(self.name): ")
        
        log(hand)
        
        let topCardOfDiscardDeck = round.discardDeck.topCard()
        log("Top Card: ","\"",topCardOfDiscardDeck.description,"\"")
        
        if (turnIsSkipped) {
            log("skipped")
            turn.skipped = true
        }
        else if (penaltiesToDraw > 0) {
            let drawn = self.drawCards(deck:round.drawDeck, count:penaltiesToDraw)
            log(" drew \(penaltiesToDraw) cards")
            
            turn.cardsDrawn = drawn
        }
        else {
            let playableCards = Hand.sortCards(hand.playableCards(on: topCardOfDiscardDeck))
            log("Playable Cards: ",playableCards.map{$0.description})
            
            if playableCards.count > 0 {
                let cardToPlay = playableCards[0]
                
                playCard(card: playableCards[0])
                log("Playing ","\"",cardToPlay.description,"\"")
                
                turn.cardPlayed = cardToPlay
            }
            else {
                let drawnCard = round.drawDeck.drawCard()
                log("Drawing a card: ", drawnCard.description)
                hand.addCard(drawnCard)
                turn.cardsDrawn.append(drawnCard)
                if (drawnCard.playable(on: topCardOfDiscardDeck)) {
                    log("Playing the drawn card")
                    playCard(card: drawnCard)
                    turn.cardPlayed = drawnCard
                }
            }
        }
        return turn
    }
}

