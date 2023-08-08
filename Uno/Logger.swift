//
//  Logger.swift
//  Uno
//
//  Created by Eric Olson on 8/2/23.
//

import Foundation

enum Logger : String {
    case Round
    case Game
    case Simulator
    case TurnHistory
    case Strategy
    case CardCounts
    case RoundCounts
    case RoundHistory
    case Deck
    case Hand
    case Card
    case Player
    case Unknown
    
    init(tag:String) {
        let baseName = URL(fileURLWithPath: tag, isDirectory: false)
            .deletingPathExtension()
            .lastPathComponent
        if let valid = Logger(rawValue: baseName) {
            self = valid
        }
        else {
            print("Logger: Unknown tag \(tag)")
            self = .Unknown
        }
    }
    
    func shouldLog() -> Bool {
        return true
        switch self {
        case .Simulator,.RoundHistory:
            return true
        case .Card,.CardCounts,.Deck,.Round,.RoundHistory,.Hand,.Player,.Strategy,.TurnHistory:
            return false
        case .Unknown:
            return true
        default:
            return true
        }
    }
    
    func log(_ anything : Any...) {
        if (!shouldLog()) {return}
        print(self.rawValue,terminator:": ")
//        print(Date().description,self.file,terminator:": ")
        anything.forEach { item in
            print(item,terminator: "")
        }
        print()
    }
}



