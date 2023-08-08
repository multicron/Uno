//
//  UnoApp.swift
//  Uno
//
//  Created by Eric Olson on 8/1/23.
//

import SwiftUI

private let log = Logger(tag:#file).log
private let log_history = Logger(tag:"RoundHistory").log

struct Round : CustomStringConvertible {
    let game: Game
    
    var drawDeck = Deck()
    var discardDeck = Deck()
    var cardCounter = CardCounts()
    var history = RoundHistory()
    var currentPlayer : Int = 0;
    var skipNextPlayer : Bool = false;
    var penaltyDrawsNextPlayer : Int = 0;
    var turnDirection : Int = 1;

    var description: String {
        return "drawDeck: \(drawDeck.description)"
    }
    
    init(game: Game) {
        
        self.game = game

        drawDeck.addStandardDeck()
        drawDeck.shuffle()
        drawDeck.addDiscardDeck(deck: discardDeck)
        

        while (drawDeck.topCard().type == .wildDraw4(color:nil).type) {
            log("Top card is a Wild +4, reshuffling Draw Deck")
            drawDeck.shuffle()
            }
                
        discardDeck.addCard(drawDeck.drawCard())

        log(self)
    }
    
     var winner : Player? {
         game.players.first( where: {$0.hasWon()})
    }
    
    var roundOver : Bool {
        return winner != nil
    }
    
    mutating func handleActionCard(_ card: Card) {
        switch card.type {
        case .skip:
            skipNextPlayer = true
        case .reverse:
            turnDirection *= -1
            // In a two-player round, Reverse == Skip
            if game.players.count==2 { skipNextPlayer = true }
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
        if (currentPlayer < 0) {currentPlayer = game.players.count - 1}
        currentPlayer %= game.players.count
    }
    
    mutating func play(turns: Int) {
        for turnNumber in 1...turns {
            log("--- Turn # \(turnNumber) ---")
            
            let player = game.players[currentPlayer]
            
            let turn = player.playOneTurn(turnIsSkipped:skipNextPlayer,
                                          penaltiesToDraw: penaltyDrawsNextPlayer)
            
            history.recordTurn(player: game.players[currentPlayer], turn: turn)

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

