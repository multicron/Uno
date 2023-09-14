//
//  NumberCardView.swift
//  Uno
//
//  Created by Eric Olson on 9/14/23.
//

import SwiftUI

struct NumberCardView: View {
    let card: Card
    
    var body: some View {
        CardView(color: card.color?.uiColor() ?? Color.white,
                 symbol: "\(card.number ?? -1)")
    }
}

#Preview {
    NumberCardView(card:Card.number(color:.yellow,number:5)).rotationEffect(Angle(degrees: 12))
}
