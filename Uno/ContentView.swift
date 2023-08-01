//
//  ContentView.swift
//  Uno
//
//  Created by Eric Olson on 8/1/23.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: UnoDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(UnoDocument()))
    }
}
