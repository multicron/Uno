//
//  CardColor.swift
//  Uno
//
//  Created by Eric Olson on 9/14/23.
//

import Foundation
import SwiftUI

enum CardColor: String, Comparable {
    case red = "Red"
    case green = "Green"
    case blue = "Blue"
    case yellow = "Yellow"
    
    static func < (color1:CardColor, color2:CardColor) -> Bool {
        return color1.rawValue < color2.rawValue
    }
    
    func uiColor() -> Color {
        switch self {
        case .red: return Color.red
        case .green: return Color.green
        case .blue: return Color.blue
        case .yellow: return Color.yellow
        }
    }
}

