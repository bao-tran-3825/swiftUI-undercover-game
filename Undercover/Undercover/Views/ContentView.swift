//
//  ContentView.swift
//  Undercover
//
//  Created by Gojo Satoru on 1/7/26.
//

import SwiftUI

enum GamePhase {
    case start, setup, reveal, discussion, voting, pigGuess, result
}

struct ContentView: View {
    @State private var viewModel = GameViewModel()

    var body: some View {
        switch viewModel.phase {
        case .start: StartView(game: viewModel)
        case .setup: SetupView(game: viewModel)
        case .reveal: RevealView(game: viewModel)
        case .discussion: DiscussionView(game: viewModel)
        case .voting: VotingView(game: viewModel)
        case .pigGuess: PigGuessView(game: viewModel)
        case .result: ResultView(game: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
