//
//  UnoCLITests.swift
//  UnoCLITests
//
//  Created by Eric Olson on 8/8/23.
//

import XCTest
@testable import Uno

final class UnoCLITests: XCTestCase {
    
    var card1 = Card.number(color:.blue, number: 5)
    var card2 = Card.number(color:.green, number: 5)
    var card3 = Card.number(color:.red, number: 5)
    var card4 = Card.number(color:.yellow, number: 5)
    
    var hand = [
        Card.number(color:.blue, number:7),
        Card.number(color:.yellow, number: 4),
        Card.number(color:.blue, number:1),
        Card.skip(color:.blue),
    ]
    
    var sortedHand = [
        Card.number(color:.blue, number:1),
        Card.number(color:.blue, number:7),
        Card.number(color:.yellow, number: 4),
        Card.skip(color:.blue),
    ]
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCompareColors() throws {
        XCTAssert(card1 < card2)
        XCTAssert(card1 < card3)
        XCTAssert(card1 < card4)
        XCTAssert(card2 < card3)
        XCTAssert(card2 < card4)
        XCTAssert(card3 < card4)
        
        XCTAssert(!(card1 < card1))
                
        XCTAssert(hand.sorted() == sortedHand)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
