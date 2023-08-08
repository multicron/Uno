//
//  Card.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

private let log = Logger(tag:#file)

enum CardEnum : Equatable, CustomStringConvertible {
    case wildDraw4
    case wild
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
    
    var type : CardEnum {self}
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
        default: return nil
        }
    }
    
    var score: Int {
        switch self {
        case .number: return self.number!
        case .draw2, .reverse, .skip: return 20
        case .wild, .wildDraw4: return 50
        }
    }
    
    var description: String {
        switch (self) {
        case .number(let color, let number): return "\(color.rawValue) \(number)"
        case .wild: return "Wild"
        case .wildDraw4: return "Wild+4"
        case .skip(let color): return "\(color.rawValue) Skip"
        case .reverse(let color): return "\(color.rawValue) Reverse"
        case .draw2(let color): return "\(color.rawValue) Draw2"
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
