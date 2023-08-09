//
//  Card.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

fileprivate let log = Logger(file:#file).log

enum Color: String, Comparable {
    case red = "Red"
    case green = "Green"
    case blue = "Blue"
    case yellow = "Yellow"
    
    static func < (color1:Color, color2:Color) -> Bool {
        return color1.rawValue < color2.rawValue
    }
}

enum Card : Equatable, Comparable, CustomStringConvertible {
    case number(color:Color,number: Int)
    case draw2(color:Color)
    case skip(color:Color)
    case reverse(color:Color)
    case wild(color:Color?)
    case wildDraw4(color:Color?)

    static let allColors : [Color] = [.red,.green,.blue,.yellow]
    static let allNumbers : [Int] = [0,1,2,3,4,5,6,7,8,9]
    
    static var zeroedCardColorCounts: [Color:Int] {
        var counts: [Color:Int] = [:]
        allColors.forEach {color in counts[color] = 0}
        return counts
    }

    static func < (card0: Card, card1: Card) -> Bool {
        switch (card0,card1) {
        case (.number(let color0, let number0),
              .number(let color1, let number1)):
            if (color0 != color1) {
                return color0 < color1
            }
            else {
                return number0 < number1
            }
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

    var number : Int? {
        switch self {
        case .number(_, let number): return number
        default: return nil
        }
    }
    
    var color: Color? {
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
    
    mutating func setColorIfWildcard(color:Color) {
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

