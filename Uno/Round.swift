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

class Round : CustomStringConvertible {
    var players : [Player] = []
    var drawDeck = Deck()
    var discardDeck = Deck()
    var cardCounter = CardCounts()
    var history = RoundHistoryItem()
    private var _currentPlayer : Int = 0
    var currentPlayer : Int = 0
    var skipNextPlayer : Bool = false
    var penaltyDrawsNextPlayer : Int = 0
    var turnDirection : Int = 1

    var description: String {
        return "drawDeck: \(drawDeck.description)"
    }
    
    init() {
        
        drawDeck.addStandardDeck()
        drawDeck.shuffle()
        drawDeck.addDiscardDeck(deck: discardDeck)
        
        log(self)
    }

    var winner : Player? {
         players.first( where: {$0.hasWon()})
    }
    
    var roundOver : Bool {
        return winner != nil
    }
    
    func addPlayer(_ player: Player) {
        players.append(player)
        player.setRound(self)
    }
    
    var score: Int { self.players.reduce(0) {accum, player in accum + player.hand.score} }

    func chooseRandomStartingPlayer() {
        currentPlayer = Int.random(in:0..<players.count)
    }
    
    func handleActionCard(_ card: Card) {
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
        case .number:
            skipNextPlayer = false
            penaltyDrawsNextPlayer = 0
        case .wild:
            break
        }
    }
    
    func handleInitialWildcard(_ card: inout Card, player: Player) {
        switch card {
        case .wildDraw4(color: _):
            assertionFailure("Card on top of discard deck at start of round is \(card)")
        case .wild:
            card.setColorIfWildcard(color: player.bestColor())
            break
        default:
            break
        }
    }
    
    func advanceToNextPlayer() {
        currentPlayer = nextPlayerIndex()
    }
    
    func nextPlayerIndex() -> Int {
        var playerIndex = currentPlayer + self.turnDirection
        if (playerIndex < 0) {playerIndex = players.count - 1}
        playerIndex %= players.count
        return playerIndex
    }
    
    func nextPlayer() -> Player {
        return players[nextPlayerIndex()]
    }
    
    func play(turns: Int) {
        
        // First player gets the effects of the first card
        //
        // If it is a "Wild", they get to choose the first color
        //
        // If it is "Wild+4" the drawDeck is shuffled
        // until the top card isn't "Wild+4"
        
        while case .wildDraw4(color:nil) = drawDeck.topCard() {
            log(drawDeck)
            log("Top card is a Wild+4, reshuffling Draw Deck")
            drawDeck.shuffle()
        }

        var firstCard = drawDeck.drawCard()
                
        log("First card in game: \(firstCard)")
        handleActionCard(firstCard)
        handleInitialWildcard(&firstCard,player: players[0])
        
        discardDeck.addCard(firstCard)

        for turnNumber in 1...turns {
            log_turns("--- Turn # \(turnNumber) ---")
            
            let player = players[currentPlayer]
            
            
            let turn = player.playOneTurn(turnIsSkipped:skipNextPlayer,
                                          penaltiesToDraw: penaltyDrawsNextPlayer,
                                          players: players)
            
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

