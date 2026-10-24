//
//  RevealViewModel.swift
//  Undercover
//
//  Holds all state and flow for the reveal screen, keeping RevealView purely about layout.
//

import SwiftUI

@Observable
final class RevealViewModel {
    /// The shared game state whose players we reveal one by one.
    let game: GameViewModel

    var currentPlayerIndex = 0
    var isWordVisible = false
    var hasConfirmedTurn = false
    var flipRotation: Double = 0

    init(game: GameViewModel) {
        self.game = game
    }

    /// Localized strings for the current language.
    var strings: Strings { game.strings }

    // MARK: - Derived values

    var players: [Player] { game.players }

    var currentPlayer: Player? {
        guard players.indices.contains(currentPlayerIndex) else { return nil }
        return players[currentPlayerIndex]
    }

    var isFirstPlayer: Bool { currentPlayerIndex == 0 }

    var navigationTitle: String {
        guard !players.isEmpty else { return "" }
        return strings.playerProgress(currentPlayerIndex + 1, players.count)
    }

    /// The pig keeps its pink accent once revealed (without leaking it beforehand);
    /// every other role uses the app theme color.
    var backgroundTint: Color {
        guard let player = currentPlayer, isWordVisible, player.role == .pig else { return .theme }
        return player.role.tintColor
    }

    /// Color for the revealed card and pass button: pink for the pig, theme for everyone else.
    func revealColor(for player: Player) -> Color {
        player.role == .pig ? player.role.tintColor : .theme
    }

    // MARK: - Flow

    func confirmTurn() {
        hasConfirmedTurn = true
    }

    /// Exit the reveal flow and go back to the setup screen.
    func returnToSetup() {
        game.phase = .setup
    }

    /// Step back to the previous player, landing on their confirmation step
    /// so the word is never shown during navigation.
    func goToPreviousPlayer() {
        guard currentPlayerIndex > 0 else { return }
        isWordVisible = false
        hasConfirmedTurn = false
        flipRotation = 0
        currentPlayerIndex -= 1
    }

    /// Flip forward to reveal the word: rotate to the edge, swap content, finish the rotation.
    func reveal() {
        withAnimation(.easeIn(duration: 0.2)) {
            flipRotation += 90
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isWordVisible = true
            withAnimation(.easeOut(duration: 0.2)) {
                self.flipRotation += 90
            }
        }
    }

    /// Move straight to the next player's confirmation step, without flipping the
    /// card back to show the image again.
    func advance() {
        withAnimation {
            isWordVisible = false
            flipRotation = 0
            hasConfirmedTurn = false
            if currentPlayerIndex < players.count - 1 {
                currentPlayerIndex += 1
            } else {
                game.phase = .discussion
            }
        }
    }
}
