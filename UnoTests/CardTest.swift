//
//  CardTest.swift
//  UnoTests
//
//  Created by Eric Olson on 8/8/23.
//

import XCTest
@testable import Uno

final class CardTest: XCTestCase {
    
    var card1 = Card.number(color:.red, number:4)
    var card2 = Card.number(color:.green, number: 4)
    var card3 : Card = .wildDraw4(color: nil)
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOne() throws {
        XCTAssert(card1 < card2)
        XCTAssert(card1 > card2)
    }
    
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//        
//        XCTAssert(1==1)
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
