//
//  UnoApp.swift
//  Uno
//
//  Created by Eric Olson on 8/1/23.
//

import SwiftUI

fileprivate let log = Logger(tag:#file).log

struct UnoApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: UnoDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
