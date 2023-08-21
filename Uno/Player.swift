//
//  Player.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

class Player : CustomStringConvertible, Hashable {
    private let uuid = UUID().uuidString
    private let strategy : Strategy
    private var round: Round? = nil
    var name: String
    private(set) var score: Int = 0
    var hand: Hand = Hand()
    var count: Int {return self.hand.count}
    

    var description: String {
        return "Player Name: \(name) Score: \(score) Hand: \(hand.description)"
    }
    
    init(_ strategy: Strategy) {
        self.strategy = strategy
        self.name = strategy.description
    }
    func resetScore() {
        score = 0
    }
    
    func otherPlayers() -> [Player] {
        if let round = self.round {
            return round.players.filter {$0 != self}
        }
        else {
            return []
        }
    }

    func setRound(_ round: Round) {
        self.round = round
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func ==(player1:Player, player2:Player) -> Bool {
        return player1.uuid == player2.uuid
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
    
    func playOneTurn(turnIsSkipped: Bool, penaltiesToDraw: Int, players: [Player]) -> TurnHistoryItem {
        
        guard let round = self.round else {fatalError("No round defined")}
        
        var turn = TurnHistoryItem()
                
        let topCardOfDiscardDeck = round.discardDeck.topCard()
        
        log("Top Card: ","\"",topCardOfDiscardDeck.description,"\"")

        log("\(self.name): ",hand)
        
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
            if var cardToPlay = pickCard(on: topCardOfDiscardDeck) {
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
    
    func pickCard(on topCardOfDiscardDeck: Card) -> Card? {
        
        guard let round = self.round else {
            return nil
        }
        
        let playableCards: [Card]
                
        if strategy.includes(.followColor) {
            playableCards = Hand.sortedCards(hand.playableCards(on: topCardOfDiscardDeck))
        }
        else {
            playableCards = Hand.sortedCards(hand.playableCards(on: topCardOfDiscardDeck),by: Card.lessThanNumberFirst)
        }

        log("Playable Cards: ",playableCards.map{$0.description})
        
        if playableCards.isEmpty {
            return nil
        }
        
        if strategy.includes(.playRandomCard) {
            return playableCards.randomElement()
        }
        
        guard let playerWithFewestCards = otherPlayers().min(by: {$0.count < $1.count}) else {
            fatalError("Can't calculate playerWithFewestCards")
        }
        
        let smallestHandCount = playerWithFewestCards.count
        log("Minimum Hands of Other Players:", smallestHandCount)
        
        let minNext = round.nextPlayer().count
        
        log("Next player has \(minNext) cards")

        let drawCards = playableCards.filter {$0.isDrawCard}
        let skipCards = playableCards.filter {$0.isSkipOrReverseCard}
        
        if strategy.includes(.zingAlways) {
            switch true {
            case !drawCards.isEmpty: return drawCards[0]
            case !skipCards.isEmpty: return skipCards[0]
            default: break
            }
        }

        if strategy.includes(.zingOnAnyoneOneCard) && smallestHandCount == 1 {
            switch true {
            case !drawCards.isEmpty: return drawCards[0]
            case !skipCards.isEmpty: return skipCards[0]
            default: break
            }
        }

        if strategy.includes(.zingOnAnyoneTwoCards) && smallestHandCount == 2 {
            switch true {
            case !drawCards.isEmpty: return drawCards[0]
            case !skipCards.isEmpty: return skipCards[0]
            default: break
            }
        }

        if (minNext == 1 && strategy.includes(.zingOnOneCard)) {
            switch true {
            case !drawCards.isEmpty: return drawCards[0]
            case !skipCards.isEmpty: return skipCards[0]
            default: break
            }
        }

        else if (minNext == 2 && strategy.includes(.zingOnTwoCards)) {
            switch true {
            case !drawCards.isEmpty: return drawCards[0]
            case !skipCards.isEmpty: return skipCards[0]
            default: break
            }
        }

    return playableCards[0]

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

