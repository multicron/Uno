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
    case Simulation
    case TurnHistory
    case Strategy
    case CardCounts
    case RoundCounts
    case GameCounts
    case RoundHistory
    case RoundTurns
    case Deck
    case Hand
    case Card
    case Player
    case Unknown
    case Unused1
    case Unused2

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
        case .Unknown:
            return true
        case .Simulation,
                .GameCounts,
                .Unused1:
            return true
        case .Card,
                .Game,
                .CardCounts,
                .Round,
                .Deck,
                .RoundCounts,
                .RoundTurns,
                .RoundHistory,
                .Hand,
                .Player,
                .Strategy,
                .TurnHistory,
                .Unused2:
            return false
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



