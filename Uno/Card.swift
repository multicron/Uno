//
//  Card.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

private let log = Logger(tag:#file)

enum Color: String {
    case red = "Red"
    case green = "Green"
    case blue = "Blue"
    case yellow = "Yellow"
}

enum CardType : String {
    case wild = "Wild"
    case wildPlus4 = "Wild +4"
    case number = "Number"
    case plus2 = "+2"
    case skip = "Skip"
    case reverse = "Reverse"
}

struct Card : Equatable, CustomStringConvertible {
    static let allColors : [Color] = [.red,.green,.blue,.yellow]
    static let allNumbers : [Int] = [0,1,2,3,4,5,6,7,8,9]
    static var zeroedCardColorCounts: [Color:Int] {
        var counts: [Color:Int] = [:]
        allColors.forEach {color in counts[color] = 0}
        return counts
    }
    
    var type: CardType;
    var number: Int?
    var color: Color?
        
    var description: String {
        if self.type == .number { return "\(color!.rawValue) \(number!)"}
        if self.type == .wild || self.type == .wildPlus4 {
            if let color = self.color {return "\(color.rawValue) \(type.rawValue)"}
            else {return "\(type.rawValue)"}
        }
        return "\(self.color!.rawValue ) \(self.type.rawValue)"
    }
    
    init(_ type: CardType) {
        self.type = type
    }
    
    init(_ type: CardType, _ color: Color) {
        self.init(type)
        self.color = color
    }
    
    init(_ type: CardType, _ color: Color, _ number: Int) {
        self.init(type, color)
        self.number = number
    }
    
    func playable(on cardInPlay: Card) -> Bool {
        if self.type == .wild { return true }
        if self.type == .wildPlus4 { return true }
        
        if self.type == .number && (self.color == cardInPlay.color) { return true}
        if self.type == .number && cardInPlay.type == .number && (self.number == cardInPlay.number) { return true}
        
        if self.color == cardInPlay.color {return true}
        if (self.type == .plus2 || self.type == .skip || self.type == .reverse) && self.type == cardInPlay.type {return true}
        
        return false
     }
}

