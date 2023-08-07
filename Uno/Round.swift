//
//  UnoApp.swift
//  Uno
//
//  Created by Eric Olson on 8/1/23.
//

import SwiftUI

private let log = Logger(tag:#file).log

struct Round : CustomStringConvertible {    
    var drawDeck = Deck()
    var discardDeck = Deck()
    var cardCounter = CardCounts()
    var history = RoundHistory()
    var players : [Player] = []
    var currentPlayer : Int = 0;
    var skipNextPlayer : Bool = false;
    var penaltyDrawsNextPlayer : Int = 0;
    var turnDirection : Int = 1;
    
    var description: String {
        return "drawDeck: \(drawDeck.description)\n" +
        (players.map { player in player.description }).joined(separator: "\n")
    }
    
      init() {
        
        log("Round.init()");

        drawDeck.addStandardDeck()
        drawDeck.shuffle()
        drawDeck.addDiscardDeck(deck: discardDeck)
        
        for name in ["Bluby","Henry","Rachel","Max"] {
            let _ = addPlayer(player: Player(round: self, name: name)).drawCards(deck:drawDeck,count:7)
         }

        while (drawDeck.topCard().type == .wildPlus4) {
            log("Top card is a Wild +4, reshuffling Draw Deck")
            drawDeck.shuffle()
            }
                
        discardDeck.addCard(drawDeck.drawCard())

        log(self)
    }
    
    mutating func addPlayer(player: Player) -> Player {
        players.append(player)
        return player
    }
    
    var winner : Player? {
        players.first( where: {$0.hasWon()})
    }
    
    var roundOver : Bool {
        return winner != nil
    }
    
    mutating func handleSpecialCard(_ card: Card) {
        switch card.type {
        case .skip:
            skipNextPlayer = true
        case .reverse:
            turnDirection *= -1
            // In a two-player round, Reverse == Skip
            if players.count==2 { skipNextPlayer = true }
        case .plus2:
            penaltyDrawsNextPlayer = 2
        case .wildPlus4:
            penaltyDrawsNextPlayer = 4
        default:
            skipNextPlayer = false
            penaltyDrawsNextPlayer = 0
        }
    }
    
    mutating func advanceToNextPlayer() {
        currentPlayer += self.turnDirection
        if (currentPlayer < 0) {currentPlayer = players.count - 1}
        currentPlayer %= players.count
    }
    
    mutating func play(turns: Int) {
        for turnNumber in 1...turns {
            log("--- Turn # \(turnNumber) ---")
            
            let player = players[currentPlayer]
            
            let turn = player.playOneTurn(turnIsSkipped:skipNextPlayer,
                                          penaltiesToDraw: penaltyDrawsNextPlayer)
            
            history.recordTurn(player: players[currentPlayer], turn: turn)

            log(turn)
            
            if let cardPlayed = turn.cardPlayed {
                handleSpecialCard(cardPlayed)
                cardCounter.countCard(card:cardPlayed)
                log(cardCounter.description)
             }
            else {
                // If no card was played by the last player, any skip or draw has been handled by now
                skipNextPlayer = false
                penaltyDrawsNextPlayer = 0
            }
            
            advanceToNextPlayer()
            
            if self.roundOver {
                log("\n" + history.description)
                return
            }
        }
    }
}

