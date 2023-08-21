//
//  Strategy.swift
//  Uno
//
//  Created by Eric Olson on 8/3/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

enum Tactic : String, CustomStringConvertible {
    case zingAlways = "zingAlways"
    case zingOnOneCard = "zingOnOneCard"
    case zingOnTwoCards = "zingOnTwoCards"
    case zingOnAnyoneOneCard = "zingOnAnyoneOneCard"
    case zingOnAnyoneTwoCards = "zingOnAnyoneTwoCards"
    case followColor = "followColor"
    case followNumber = "followNumber"
    case playRandomCard = "playRandomCard"
    
    var description: String { self.rawValue }
}

struct Strategy {
    var list: [Tactic] = []
    
    init(_ strategies : Tactic...) {
        self.list = strategies
    }
    
    var description: String {
        self.list.map{tactic in tactic.description}.joined(separator: ", ")
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
