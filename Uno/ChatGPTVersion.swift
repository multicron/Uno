enum UnoColor: String, CaseIterable {
    case red, blue, green, yellow
    case wild
}

enum UnoValue {
    case number(Int)
    case skip, reverse, drawTwo
    case wild, wildDrawFour
}

struct UnoCard {
    let color: UnoColor
    let value: UnoValue
}

struct UnoDeck {
    var cards: [UnoCard] = []
    
    init() {
        for color in UnoColor.allCases {
            if color != .wild {
                for number in 0...9 {
                    cards.append(UnoCard(color: color, value: .number(number)))
                    if number != 0 {
                        cards.append(UnoCard(color: color, value: .number(number)))
                    }
                }
                for _ in 0..<2 {
                    cards.append(UnoCard(color: color, value: .skip))
                    cards.append(UnoCard(color: color, value: .reverse))
                    cards.append(UnoCard(color: color, value: .drawTwo))
                }
            }
        }
        for _ in 0..<4 {
            cards.append(UnoCard(color: .wild, value: .wild))
            cards.append(UnoCard(color: .wild, value: .wildDrawFour))
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func drawCard() -> UnoCard? {
        if cards.isEmpty {
            return nil
        }
        return cards.removeLast()
    }
}

struct UnoPlayer {
    let name: String
    var hand: [UnoCard] = []
    
    mutating func drawCards(_ count: Int, from deck: inout UnoDeck) {
        for _ in 0..<count {
            if let card = deck.drawCard() {
                hand.append(card)
            }
        }
    }
    
    mutating func playCard(at index: Int, on pile: inout [UnoCard]) {
        let playedCard = hand.remove(at: index)
        pile.append(playedCard)
    }
}

// Main simulation
func simulateUnoGame() {
    var deck = UnoDeck()
    var pile = UnoDeck()
    
    // Shuffle the deck and draw initial cards
    deck.shuffle()
    var players: [UnoPlayer] = [
        UnoPlayer(name: "Player 1"),
        UnoPlayer(name: "Player 2"),
        UnoPlayer(name: "Player 3"),
        UnoPlayer(name: "Player 4")
    ]
    
    for i in 0..<players.count {
        players[i].drawCards(7, from: &deck)
    }
    
    var totalScore = [Int](repeating: 0, count: players.count) // Store total scores for each player
    
    // Continue rounds until a player reaches 500 points
    while !players.isEmpty {
        // Simulate game round
        simulateGameRound(players: &players, deck: &deck, pile: &pile)
        
        // Calculate and display current total scores
        for i in 0..<players.count {
            let playerScore = players[i].hand.reduce(0) { $0 + scoreForCard($1) }
            totalScore[i] += playerScore
            print("\(players[i].name) has \(players[i].hand.count) cards and scores \(playerScore) points. Total score: \(totalScore[i])")
        }
        
        // Check if any player has reached 500 points
        if let winnerIndex = totalScore.firstIndex(where: { $0 >= 500 }) {
            print("\(players[winnerIndex].name) wins with a total score of \(totalScore[winnerIndex])!")
            break
        }
    }
    
    print("Game over!")
}

// Simulate a single game round
func simulateGameRound(players: inout [UnoPlayer], deck: inout UnoDeck, pile: inout UnoDeck) {
    // Simulate game rounds
    var currentPlayerIndex = 0
    var direction: Int = 1 // 1 for clockwise, -1 for counter-clockwise
    
    while !players.isEmpty {
        let currentPlayer = players[currentPlayerIndex]
        print("\(currentPlayer.name)'s turn!")
        
        // Display top card on discard pile
        if let topCard = pile.cards.last {
            print("Top card on discard pile: \(topCard.color.rawValue) \(topCard.value)")
        }
        
        // Simulate player's turn
        if let playableCardIndex = currentPlayer.hand.firstIndex(where: { canPlayCard($0, on: pile.cards.last) }) {
            let playedCard = currentPlayer.hand[playableCardIndex]
            currentPlayer.playCard(at: playableCardIndex, on: &pile.cards)
            
            // Handle special card effects
            switch playedCard.value {
            case .skip:
                print("\(currentPlayer.name) skips the next player's turn.")
                currentPlayerIndex = (currentPlayerIndex + direction * 2 + players.count) % players.count
            case .reverse:
                print("Direction of play is reversed.")
                direction *= -1
            case .drawTwo:
                let nextPlayerIndex = (currentPlayerIndex + direction + players.count) % players.count
                var nextPlayer = players[nextPlayerIndex]
                nextPlayer.drawCards(2, from: &deck)
                players[nextPlayerIndex] = nextPlayer
                print("\(currentPlayer.name) makes the next player draw 2 cards.")
            default:
                break
            }
            
            // Check for Uno (one card left)
            if currentPlayer.hand.count == 1 {
                print("\(currentPlayer.name) shouts 'UNO!'")
            }
            
            // Check for a win (no cards left)
            if currentPlayer.hand.isEmpty {
                print("\(currentPlayer.name) wins!")
                players.removeAll { $0.name == currentPlayer.name }
                if players.count == 1 {
                    print("\(players[0].name) wins by default!")
                    players.removeAll()
                }
            }
        } else {
            // Player cannot play, draw a card from the deck
            if let drawnCard = deck.drawCard() {
                print("\(currentPlayer.name) draws a card: \(drawnCard.color.rawValue) \(drawnCard.value)")
                if canPlayCard(drawnCard, on: pile.cards.last) {
                    print("\(currentPlayer.name) plays drawn card!")
                    currentPlayer.playCard(at: currentPlayer.hand.count - 1, on: &pile.cards)
                } else {
                    currentPlayer.hand.append(drawnCard)
                    print("\(currentPlayer.name) cannot play drawn card.")
                }
            } else {
                print("Draw deck is empty. Reshuffling discard pile.")
                let topCard = pile.cards.removeLast()
                deck = pile
                deck.shuffle()
                pile = UnoDeck()
                pile.cards.append(topCard)
            }
        }
        
        // Move to the next player
        currentPlayerIndex = (currentPlayerIndex + direction + players.count) % players.count
    }
}

// Check if a card can be played on top of another card
func canPlayCard(_ card: UnoCard, on topCard: UnoCard?) -> Bool {
    guard let topCard = topCard else {
        return true
    }
    
    switch card.color {
    case .wild:
        return true
    case .red, .blue, .green, .yellow:
        switch card.value {
        case .number(let number):
            if case .number(let topNumber) = topCard.value {
                return number == topNumber
            }
        default:
            return card.color == topCard.color || card.value == topCard.value
        }
    }
}

// Calculate the score for a card
func scoreForCard(_ card: UnoCard) -> Int {
    switch card.value {
    case .number(let number):
        return number
    case .skip, .reverse, .drawTwo:
        return 20
    case .wild, .wildDrawFour:
        return 50
    }
}

// Start the simulation
simulateUnoGame()
