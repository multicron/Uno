//
//  SpecialCardView.swift
//  Uno
//
//  Created by Eric Olson on 9/14/23.
//

import SwiftUI

struct SpecialCardView: View {
    let card: Card
    
    func getColorAndSymbol(_ card:Card) -> (CardColor?,String) {
        let color=card.color
        switch card {
        case .number(let color, let number): return (color,"\(number)")
        case .draw2: return (color,"+2")
        case .reverse: return (color,"🔄")
        case .skip: return (color,"🚫")
        case .wild(let color): return (color,"Wild")
        case .wildDraw4(let color): return (color,"W+4")
        }
    }
    
    var body: some View {
        let (color,symbol) = getColorAndSymbol(card)
        
        CardView(color: color?.uiColor() ?? Color.teal,
                 symbol: symbol)
    }
}

#Preview {
    SpecialCardView(card:Card.wild(color:nil)).rotationEffect(Angle(degrees: 12))
}
