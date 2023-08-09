//
//  UnoApp.swift
//  Uno
//
//  Created by Eric Olson on 8/1/23.
//

import SwiftUI

fileprivate let log = Logger(file:#file).log
fileprivate let log_history = Logger(tag:"RoundHistory").log
fileprivate let log_turns = Logger(tag:"RoundTurns").log

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
        

        log(self)

        while case .wildDraw4(color:nil) = drawDeck.topCard() {
            log("Top card is a Wild+4, reshuffling Draw Deck")
            drawDeck.shuffle()
            }
                
        discardDeck.addCard(drawDeck.drawCard())
    }

    var winner : Player? {
         players.first( where: {$0.hasWon()})
    }
    
    var roundOver : Bool {
        return winner != nil
    }
    
    mutating func addPlayer(_ player: Player) {
        players.append(player)
        player.setRound(self)
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
    
    mutating func handleInitialWildcard(_ card: Card, player: Player) {
        switch card {
        case .wildDraw4(color: _):
            assertionFailure("Card on top of discard deck at start of play is \(card)")
        case .wild:
            // TODO: Make the first player choose the color
            break
        default:
            break
        }
    }
    
    mutating func advanceToNextPlayer() {
        currentPlayer += self.turnDirection
        if (currentPlayer < 0) {currentPlayer = players.count - 1}
        currentPlayer %= players.count
    }
    
    mutating func play(turns: Int) {
        
        // First player gets the effects of the first card
        //
        // If it is a "Wild", they get to choose the first color
        //
        // It cannot be "Wild+4" because the initial drawDeck is shuffled
        // until the top card isn't "Wild+4"
        
        log("First card in game: \(discardDeck.topCard())")
        handleActionCard(discardDeck.topCard())
        handleInitialWildcard(discardDeck.topCard(),player: players[0])
        
        for turnNumber in 1...turns {
            log_turns("--- Turn # \(turnNumber) ---")
            
            let player = players[currentPlayer]
            
            
            let turn = player.playOneTurn(turnIsSkipped:skipNextPlayer,
                                          penaltiesToDraw: penaltyDrawsNextPlayer)
            
            history.recordTurn(player: player, turn: turn)

            log_turns(turn)
            
            if let cardPlayed = turn.cardPlayed {
                handleActionCard(cardPlayed)
                cardCounter.countCard(card:cardPlayed)
                log_turns(cardCounter.description)
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

