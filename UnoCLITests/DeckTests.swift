//
//  HandTests.swift
//  UnoCLITests
//
//  Created by Eric Olson on 8/9/23.
//

import XCTest

final class DeckTests: XCTestCase {
    
    var stdDeck1 = Deck()
    var stdDeck2 = Deck()
    var testDeck1 = Deck()

    override func setUpWithError() throws {
        stdDeck1 = Deck()
        stdDeck1.addStandardDeck()
        
        stdDeck2 = Deck()
        stdDeck2.addStandardDeck()
        
        testDeck1 = Deck()
    }
    
    override func tearDownWithError() throws {
    }
    
    func testSize() throws {
        XCTAssert(stdDeck1.count == 108)
    }
    
    func testEquality() throws {
        XCTAssert(stdDeck1 == stdDeck2)
    }
    
    func testShuffle() throws {
        stdDeck1.shuffle()
        stdDeck2.shuffle()
        
        // There is a very tiny chance the two shuffles are the same!
        
        XCTAssert(stdDeck1.cards != stdDeck2.cards)
    }
 
    func testSort() throws {
        stdDeck1.shuffle()
        stdDeck2.shuffle()

        let sort1 = Deck.sortCards(stdDeck1.cards)
        let sort2 = Deck.sortCards(stdDeck2.cards)
        
        XCTAssert(sort1 == sort2)
    }

    func testSortAlreadySorted() throws {
        stdDeck1.shuffle()

        let sort1 = Deck.sortCards(stdDeck1.cards)
        let sort2 = Deck.sortCards(sort1)
    
        XCTAssertEqual(sort1,sort2,"Sorting an already sorted deck didn't produce the same deck")
    }
    
    func testEmpty() throws {
        XCTAssertEqual(testDeck1.count, 0,"Empty deck has a count of 0")
        XCTAssertEqual(Deck.sortCards(testDeck1.cards),[],"Sorting an empty deck didn't produce an empty array")
    }

    func testOneCard() throws {
        
        testDeck1.addCard(.skip(color: .red))
        
        XCTAssertEqual(testDeck1.count, 1,"Deck of size 1 has count != 1")
        
        XCTAssertEqual(Deck.sortCards(testDeck1.cards),
                       testDeck1.cards,
                       "Sorting a deck of size 1 didn't produce and equal deck")
    }

    func testTopCardAndDraw() throws {
        
        let topCard = stdDeck1.topCard()
        let drawnCard = stdDeck1.drawCard()

        XCTAssertEqual(topCard, Card.number(color:.yellow,number:9),"Top card of new deck isn't Yellow 9")
        XCTAssertEqual(topCard, drawnCard, "Top card isn't the same as drawn card")
    }
    
    func testReshuffle() throws {
        
        testDeck1.addDiscardDeck(deck: stdDeck1)
        
        testDeck1.reshuffle()
        
        XCTAssertEqual(testDeck1.count, 107, "After reshuffle, deck wasn't 107 cards")
                
        guard let discDeck = testDeck1.discardDeck else { return XCTFail("No discardDeck after reshuffle") }
        
        XCTAssertEqual(discDeck.count, 1, "After reshuffle, discardDeck doesn't contain one card")
    }
    
}
