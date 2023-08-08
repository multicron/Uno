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
    case RoundTurns
    case Deck
    case Hand
    case Card
    case Player
    case Unknown
    
    init(tag:String) {
        if let valid = Logger(rawValue: tag) {
            self = valid
        }
        else {
            print("Logger: Unknown tag \(tag)")
            self = .Unknown
        }
    }
    
    init(file:String) {
        let baseName = URL(fileURLWithPath: file, isDirectory: false)
            .deletingPathExtension()
            .lastPathComponent
        self.init(tag: baseName)
    }
    
    func shouldLog() -> Bool {
//        return true
        switch self {
        case .Simulator,
                .Game,
                .RoundCounts:
            return true
        case .Card,
                .CardCounts,
                .Round,
                .Deck,
                .RoundTurns,
                .RoundHistory,
                .Hand,
                .Player,
                .Strategy,
                .TurnHistory:
            return false
        case .Unknown:
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



