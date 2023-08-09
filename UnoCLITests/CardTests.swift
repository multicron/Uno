//
//  UnoCLITests.swift
//  UnoCLITests
//
//  Created by Eric Olson on 8/8/23.
//

import XCTest

final class CardTests: XCTestCase {
    
    var unsortedCardArray = [
        Card.skip(color:.blue),
        Card.number(color:.blue, number:7),
        Card.number(color:.yellow, number: 4),
        Card.number(color:.blue, number:1),
    ]
    
    var sortedCardArray = [
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
        // Colors sort properly
        
        XCTAssert(Card.number(color:.blue,number:5) < Card.number(color:.green,number:5))
        XCTAssert(Card.number(color:.green,number:5) < Card.number(color:.red,number:5))
        XCTAssert(Card.number(color:.red,number:5) < Card.number(color:.yellow,number:5))
    }
    
    func testCompareNumbers() throws {
        
        // Numbers sort properly
        
        XCTAssert(Card.number(color:.blue,number:0) < Card.number(color:.blue,number:1))
        XCTAssert(Card.number(color:.blue,number:5) < Card.number(color:.blue,number:6))
        XCTAssert(Card.number(color:.blue,number:6) < Card.number(color:.blue,number:9))
    }
    
    func testEquality() throws {
        
        // Equality works
        
        XCTAssert(Card.number(color:.blue,number:0) == Card.number(color:.blue,number:0))
        XCTAssert(Card.skip(color:.blue) == Card.skip(color:.blue))
        XCTAssert(Card.reverse(color:.blue) == Card.reverse(color:.blue))
    }
    
    func testSorting() throws {
        // Sorting an array of Cards works
        
        XCTAssert(unsortedCardArray.sorted() == sortedCardArray)
    }
    
    func testWildCardColors() {
        // Wildcards differ once they have been assigned a color
        
        XCTAssert(Card.wild(color:nil) == Card.wild(color:nil))
        XCTAssert(Card.wild(color:.blue) == Card.wild(color:.blue))
        XCTAssert(Card.wild(color:nil) != Card.wild(color:.blue))
        XCTAssert(Card.wild(color:.red) != Card.wild(color:.blue))
        
        // Setting the color of a Wildcard works
        
        var wildCard = Card.wild(color:nil)
        wildCard.setColorIfWildcard(color: .red)
        XCTAssert(wildCard == Card.wild(color:.red))
        
        // Setting the color of a non-wildcard is ignored
        
        var numCard = Card.skip(color:.blue)
        numCard.setColorIfWildcard(color: .red)
        XCTAssert(numCard == Card.skip(color:.blue))
        
    }
}
