//
//  UndercoverApp.swift
//  Undercover
//
//  Created by Gojo Satoru on 1/7/26.
//

import SwiftUI

@main
struct UndercoverApp: App {
    @State private var gameViewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(gameViewModel)
        }
    }
}
