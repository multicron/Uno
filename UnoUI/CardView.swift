//
//  Card.swift
//  Cardo
//
//  Created by Eric Olson on 9/14/23.
//

import SwiftUI

struct CardView: View {
    var color: Color = Color.white
    let symbol: String
    
    var body: some View {
        
 
        VStack {
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .frame(width: 112, height: 178)
                .foregroundColor(color)
                .overlay(
                    
                    VStack {
                        HStack {
                            Text(symbol)
                                .font(.title)
                                .fontWeight(.medium)
                            .frame(width: .infinity, alignment:.topLeading)
                            .padding(4)
                            Spacer()
                        }
                        
                        Spacer()
 
                        Text(symbol)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
 
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text(symbol)
                                .font(.title)
                                .fontWeight(.medium)
                            .frame(width: .infinity, alignment:.topTrailing)
                            .padding(4)
                            .rotationEffect(Angle(degrees:180))
                        }
                    }
                )
        }
    }
}

#Preview {
    CardView(color:Color.purple,symbol:"X")
        .rotationEffect(Angle(degrees: 12))
}
