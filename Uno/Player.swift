//
//  Player.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

private let log = Logger(tag:#file).log

struct Player : CustomStringConvertible, Hashable {
    let game: Game
    let name: String
    private let score: Int = 0
    var hand: Hand = Hand()
    var description: String {
        return "Player Name: \(name) Score: \(score) Hand: \(hand.description)"
    }
    
    init(game: Game, name: String) {
        self.game = game
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
        
     }
    
    func playOneTurn(turnIsSkipped: Bool, penaltiesToDraw: Int) -> TurnHistory {
        
        var turn = TurnHistory()
        
        log("\(self.name): ")
        
        log(hand)
        
        let topCardOfDiscardDeck = game.currentRound!.discardDeck.topCard()
        log("Top Card: ","\"",topCardOfDiscardDeck.description,"\"")
        
        if (turnIsSkipped) {
            log("skipped")
            turn.skipped = true
        }
        else if (penaltiesToDraw > 0) {
            let drawn = self.drawCards(deck:game.currentRound!.drawDeck, count:penaltiesToDraw)
            log(" drew \(penaltiesToDraw) cards")
            
            turn.cardsDrawn = drawn
        }
        else {
            let playableCards = Hand.sortCards(hand.playableCards(on: topCardOfDiscardDeck))
            log("Playable Cards: ",playableCards.map{$0.description})
            
            if !playableCards.isEmpty {
                var cardToPlay = playableCards[0]
                let _ = hand.removeCard(cardToPlay)
                
                let bestColor = self.hand.bestColor()
                cardToPlay.setColor(color: bestColor ?? Color.red)
                
                log("Playing ","\"",cardToPlay.description,"\"")
                
                game.currentRound!.discardDeck.addCard(cardToPlay)

                turn.cardPlayed = cardToPlay
            }
            else {
                let drawnCard = game.currentRound!.drawDeck.drawCard()
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

