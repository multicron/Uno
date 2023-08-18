//
//  UnderstandingTests.swift
//  UnoCLITests
//
//  Created by Eric Olson on 8/10/23.
//

import XCTest

final class UnderstandingTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReduce() throws {
        let nums = Array(1...10)
        
        XCTAssert(nums.reduce(0,+) == 1+2+3+4+5+6+7+8+9+10)
    }
    
    func testReduceRange() throws {
        let r = 1...10
        
        factorial(5)
        
        XCTAssert(r.reduce(0,+) == 1+2+3+4+5+6+7+8+9+10)
        r.forEach {print($0)}
    }

    func factorial(_ n:Int) {
        let r = 1...n
        
        print(r.reduce(1,*))
    }
}
