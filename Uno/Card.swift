//
//  Card.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

enum Card : Equatable, Comparable, CustomStringConvertible, Hashable, Identifiable {
    
    case number(color:CardColor,number: Int)
    case draw2(color:CardColor)
    case skip(color:CardColor)
    case reverse(color:CardColor)
    case wild(color:CardColor?)
    case wildDraw4(color:CardColor?)

    static let allColors : [CardColor] = [.blue,.green,.red,.yellow]
    static let allNumbers : [Int] = [0,1,2,3,4,5,6,7,8,9]
    
    var id: Self {
            return self
        }
    
    static var zeroedCardColorCounts: [CardColor:Int] {
        var counts: [CardColor:Int] = [:]
        allColors.forEach {color in counts[color] = 0}
        return counts
    }

    static func compareWildCards (color0: CardColor?, color1: CardColor?) -> Bool {
        // Returns true for "<", false for ">="
        
        // No color assigned is sorted less than color assigned
        if color0 == nil && color1 != nil { return true }
        if color0 != nil && color1 == nil { return false }
        
        // If both have a color assigned, compare the colors
        if let c0 = color0, let c1 = color1 {
            return c0 < c1
        }
        // Otherwise, neither has a color assigned and they are equal
        else {
            return false
        }
    }
    
    static func < (card0: Card, card1: Card) -> Bool {
        return lessThanColorFirst(card0: card0, card1: card1)
    }
    
    static func lessThanNumberFirst (card0: Card, card1: Card) -> Bool {
        switch (card0,card1) {
            // Number cards are sorted by number and then color
        case (.number(let color0, let number0),
              .number(let color1, let number1)):
            if (number0 != number1) {
                return number0 < number1
            }
            else {
                return color0 < color1
            }
        default:
            return lessThanColorFirst(card0:card0, card1:card1)
        }
    }
    
    static func lessThanColorFirst (card0: Card, card1: Card) -> Bool {
        switch (card0,card1) {
            
        // Number cards are sorted by color and then number
        case (.number(let color0, let number0),
              .number(let color1, let number1)):
            if (color0 != color1) {
                return color0 < color1
            }
            else {
                return number0 < number1
            }

        // Colored action cards are sorted by color
        case (.skip(let color0),.skip(let color1)):
            return color0 < color1
        case (.reverse(let color0),.reverse(let color1)):
            return color0 < color1
        case (.draw2(let color0),.draw2(let color1)):
            return color0 < color1

        // Wildcards are sorted by color, if any

        case (.wild(let color0),.wild(let color1)):
            return Self.compareWildCards(color0: color0, color1: color1)

        case (.wildDraw4(let color0),.wildDraw4(let color1)):
            return Self.compareWildCards(color0: color0, color1: color1)

        // The rest of these cases sort the card types into the order
        // .number, .skip, .reverse, .draw2, .wild, .wildDraw4
            
        case (.number, .reverse) : return true
        case (.number, .draw2): return true
        case (.number, .skip) : return true
        case (.number, .wild) : return true
        case (.number, .wildDraw4) : return true
        case (.skip, .reverse): return true
        case (.skip, .draw2): return true
        case (.skip, .wild): return true
        case (.skip, .wildDraw4): return true
        case (.reverse, .draw2): return true
        case (.reverse, .wild): return true
        case (.reverse, .wildDraw4): return true
        case (.draw2, .wild): return true
        case (.draw2, .wildDraw4): return true
        case (.wild, .wildDraw4): return true
        default: return false
        }
    }

    var isDrawCard : Bool {
        switch self {
        case .draw2, .wildDraw4:
            return true
        default:
            return false
        }
    }

    var isSkipOrReverseCard : Bool {
        switch self {
        case .skip,.reverse:
            return true
        default:
            return false
        }
    }

    var number : Int? {
        switch self {
        case .number(_, let number): return number
        default: return nil
        }
    }
    
    var color: CardColor? {
        switch self {
        case .number(let color, _): return color
        case .draw2(let color): return color
        case .skip(let color): return color
        case .reverse(let color): return color
        case .wild(let color): return color
        case .wildDraw4(let color): return color
        }
    }
    
    var score: Int {
        switch self {
        case .number(_, let number): return number
        case .draw2, .reverse, .skip: return 20
        case .wild, .wildDraw4: return 50
        }
    }
    
    var description: String {
        switch (self) {
        case .number(let color, let number): return "\(color.rawValue) \(number)"
        case .wild(let color): return [color?.rawValue, "Wild"].compactMap{$0}.joined(separator: " ")
        case .wildDraw4(let color): return [color?.rawValue, "Wild+4"].compactMap{$0}.joined(separator: " ")
        case .skip(let color): return "\(color.rawValue) Skip"
        case .reverse(let color): return "\(color.rawValue) Reverse"
        case .draw2(let color): return "\(color.rawValue) Draw2"
        }
    }
    
    mutating func setColorIfWildcard(color:CardColor) {
        switch self {
        case .wild: self = .wild(color:color)
        case .wildDraw4: self = .wildDraw4(color: color)
        default: break
        }
    }
    
    func playable(on cardInPlay: Card) -> Bool {
        switch (self, cardInPlay) {
        case (.wild,_):
            return true
        case (.wildDraw4,_):
            return true
        case (.number(let color, let number),_):
            return color==cardInPlay.color || number==cardInPlay.number
        case (.draw2(let color), _):
            return color==cardInPlay.color
        case (.reverse(let color), _):
            return color==cardInPlay.color
        case (.skip(let color), _):
            return color==cardInPlay.color
        }
    }
}

