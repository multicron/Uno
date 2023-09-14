//
//  HandView.swift
//  Uno
//
//  Created by Eric Olson on 9/14/23.
//

import SwiftUI

struct HandView: View {
    let hand: Hand
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hand.cards.sorted(), content: {card in
                    SpecialCardView(card:card )
                }
                )
            }
        }.padding()
    }
}

#Preview {
    let hand = Hand()
    
    hand.addStandardDeck()
    
    return HandView(hand:hand)
}
