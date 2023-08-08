//
//  Player.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

class Player : CustomStringConvertible, Hashable {
    private var round: Round? = nil
    let name: String
    private(set) var score: Int = 0
    var hand: Hand = Hand()
    var description: String {
        return "Player Name: \(name) Score: \(score) Hand: \(hand.description)"
    }
    
    init(name: String) {
        self.name = name
    }
    
    func setRound(_ round: Round) {
        self.round = round
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
    
    func addScore(_ score: Int) {
        self.score += score
    }
    
    func newHand() {
        self.hand = Hand()
    }
    
    func drawCards(count: Int = 1) -> [Card] {
        guard let round = self.round else {fatalError("No round defined")}

        var drawn : [Card] = []
        for _ in 1...count {
            let card = round.drawDeck.drawCard()
            drawn.append(card)
            hand.addCard(card)
        }
        return drawn
    }
    
    func playOneTurn(turnIsSkipped: Bool, penaltiesToDraw: Int) -> TurnHistoryItem {
        
        guard let round = self.round else {fatalError("No round defined")}
        
        var turn = TurnHistoryItem()
        
        log("\(self.name): ")
        
        log(hand)
        
        let topCardOfDiscardDeck = round.discardDeck.topCard()
        
        log("Top Card: ","\"",topCardOfDiscardDeck.description,"\"")
        
        if (turnIsSkipped) {
            log("skipped")
            turn.skipped = true
        }
        else if (penaltiesToDraw > 0) {
            let drawn = self.drawCards(count:penaltiesToDraw)
            log(" drew \(penaltiesToDraw) cards")
            
            turn.cardsDrawn = drawn
        }
        else {
            let playableCards = Hand.sortCards(hand.playableCards(on: topCardOfDiscardDeck))
            log("Playable Cards: ",playableCards.map{$0.description})
            
            if !playableCards.isEmpty {
                var cardToPlay = playableCards[0]
                playCard(card: &cardToPlay)
                turn.cardPlayed = cardToPlay
            }
            else {
                var drawnCard = round.drawDeck.drawCard()
                log("Drawing a card: ", drawnCard.description)
                hand.addCard(drawnCard)
                turn.cardsDrawn.append(drawnCard)
                // TODO: Check if drawn Wild+4 can be played
                if (drawnCard.playable(on: topCardOfDiscardDeck)) {
                    log("Playing the drawn card")
                    playCard(card: &drawnCard)
                    turn.cardPlayed = drawnCard
                }
            }
        }
        return turn
    }
    
    func playCard(card: inout Card) {
        guard let round = self.round else {fatalError("No round defined")}

        let _ = hand.removeCard(card)
        
        let bestColor = self.hand.bestColor()
        card.setColorIfWildcard(color: bestColor ?? Color.red)
        
        log("Playing ","\"",card.description,"\"")
        
        round.discardDeck.addCard(card)
    }
}

