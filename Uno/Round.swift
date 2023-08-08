//
//  UnoApp.swift
//  Uno
//
//  Created by Eric Olson on 8/1/23.
//

import SwiftUI

fileprivate let log = Logger(tag:#file).log
fileprivate let log_history = Logger(tag:"RoundHistory").log

struct Round : CustomStringConvertible {
    var players : [Player] = []
    var drawDeck = Deck()
    var discardDeck = Deck()
    var cardCounter = CardCounts()
    var history = RoundHistoryItem()
    var currentPlayer : Int = 0;
    var skipNextPlayer : Bool = false;
    var penaltyDrawsNextPlayer : Int = 0;
    var turnDirection : Int = 1;

    var description: String {
        return "drawDeck: \(drawDeck.description)"
    }
    
    init() {
        
        drawDeck.addStandardDeck()
        drawDeck.shuffle()
        drawDeck.addDiscardDeck(deck: discardDeck)
        

        while (drawDeck.topCard() == .wildDraw4(color:nil)) {
            log("Top card is a Wild +4, reshuffling Draw Deck")
            drawDeck.shuffle()
            }
                
        discardDeck.addCard(drawDeck.drawCard())

        log(self)
    }

    var winner : Player? {
         players.first( where: {$0.hasWon()})
    }
    
    var roundOver : Bool {
        return winner != nil
    }
    
    mutating func addPlayer(_ player: Player) -> Player {
        players.append(player)
        return player
    }
    
    var score: Int { self.players.reduce(0) {accum, player in accum + player.hand.score} }

    
    mutating func handleActionCard(_ card: Card) {
        switch card {
        case .skip:
            skipNextPlayer = true
        case .reverse:
            turnDirection *= -1
            // In a two-player round, Reverse == Skip
            if players.count==2 { skipNextPlayer = true }
        case .draw2:
            penaltyDrawsNextPlayer = 2
        case .wildDraw4:
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
            
            history.recordTurn(player: player, turn: turn)

            log(turn)
            
            if let cardPlayed = turn.cardPlayed {
                handleActionCard(cardPlayed)
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
                log_history("\n" + history.description)
                return
            }
        }
    }
}

