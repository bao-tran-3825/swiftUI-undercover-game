//
//  PigGuessView.swift
//  Undercover
//
//  Shown when the pig is voted out: the pig gets one chance to guess the
//  civilians' word out loud. The players themselves decide whether the guess
//  was right and tap the matching button — the app does no word checking.
//

import SwiftUI

struct PigGuessView: View {
    let game: GameViewModel

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            SpotlightGradient(color: .pigRole, intensity: 0.25)

            VStack(spacing: 24) {
                Spacer()

                Text("🐷")
                    .font(.system(size: 90))

                Text(game.strings.pigExposedTitle)
                    .font(.stampedHeader(34))
                    .textCase(.uppercase)
                    .foregroundStyle(Color.pigRole)

                Text(game.strings.pigGuessDesc)
                    .font(.subheadline)
                    .foregroundStyle(Color.pigRole)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        game.result = .pigWins
                        game.phase = .result
                    } label: {
                        Label(game.strings.pigGuessCorrect, systemImage: "checkmark.circle.fill")
                    }
                    .buttonStyle(ThemeButtonStyle(color: .pigRole, style: .prominent))

                    Button {
                        game.advanceAfterElimination()
                    } label: {
                        Label(game.strings.pigGuessWrong, systemImage: "xmark.circle")
                    }
                    .buttonStyle(ThemeButtonStyle(color: .pigRole, style: .outline))
                }
                .frame(maxWidth: 420)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    PigGuessView(game: GameViewModel())
}
