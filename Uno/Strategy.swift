//
//  Strategy.swift
//  Uno
//
//  Created by Eric Olson on 8/3/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

enum Tactic {
    case zingAlways
    case zingOnOneCard
    case zingOnTwoCards
    case zingOnAnyoneOneCard
    case zingOnAnyoneTwoCards
    case followColor
    case followNumber
}

struct Strategy {
    var list: [Tactic] = []
    
    init(_ strategies : Tactic...) {
        self.list = strategies
    }
    
    func includes(_ item: Tactic) -> Bool {
        return list.contains(item)
    }
    
    func shouldZing() {}
    
    func followColor() {}
    
    func followNumber() {}
    
    func followZinger() {}
    
    func holdWildCards() {}
    
    func holdZingers() {}
    
}
