//
//  Card.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

private let log = Logger(tag:#file).log

enum Color: String {
    case red = "Red"
    case green = "Green"
    case blue = "Blue"
    case yellow = "Yellow"
}

enum Card : Equatable, CustomStringConvertible {
    case wildDraw4(color:Color?)
    case wild(color:Color?)
    case draw2(color:Color)
    case skip(color:Color)
    case reverse(color:Color)
    case number(color:Color,number: Int)
    
    static let allColors : [Color] = [.red,.green,.blue,.yellow]
    static let allNumbers : [Int] = [0,1,2,3,4,5,6,7,8,9]
    
    static var zeroedCardColorCounts: [Color:Int] {
        var counts: [Color:Int] = [:]
        allColors.forEach {color in counts[color] = 0}
        return counts
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

