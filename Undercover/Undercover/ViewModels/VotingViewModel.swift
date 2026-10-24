//
//  VotingViewModel.swift
//  Undercover
//
//  Holds the state and flow for the voting screen, keeping VotingView purely about layout.
//

import SwiftUI

@Observable
final class VotingViewModel {
    /// The shared game state whose players are voted out one round at a time.
    let game: GameViewModel

    /// The player currently tapped as the vote target, if any.
    var selectedPlayerID: UUID?
    var showEliminationAlert = false
    /// Announcement shown right after a vote, revealing who was eliminated and their role.
    var showEliminationResult = false
    /// The player just voted out, held for the announcement.
    var lastEliminated: Player?

    init(game: GameViewModel) {
        self.game = game
    }

    /// Localized strings for the current language.
    var strings: Strings { game.strings }

    // MARK: - Derived values

    /// Players still in the game, shown as the votable candidates.
    var candidates: [Player] {
        game.activePlayers
    }

    var selectedPlayer: Player? {
        guard let id = selectedPlayerID else { return nil }
        return candidates.first { $0.id == id }
    }

    var canEliminate: Bool { selectedPlayer != nil }

    var navigationTitle: String { strings.roundTitle(game.currentRound) }

    /// Confirmation message naming the player about to be eliminated.
    var eliminationMessage: String {
        guard let player = selectedPlayer else { return "" }
        return strings.eliminationConfirm(player.name)
    }

    // MARK: - Selection

    func select(_ player: Player) {
        selectedPlayerID = (selectedPlayerID == player.id) ? nil : player.id
    }

    func isSelected(_ player: Player) -> Bool {
        selectedPlayerID == player.id
    }

    // MARK: - Flow

    /// Ask for confirmation before eliminating the selected player.
    func requestElimination() {
        guard canEliminate else { return }
        showEliminationAlert = true
    }

    /// Eliminate the selected player. A voted-out pig goes to the guess screen;
    /// anyone else is revealed in an announcement.
    func confirmElimination() {
        guard let id = selectedPlayerID,
              let player = candidates.first(where: { $0.id == id }) else { return }
        game.eliminate(playerID: id)
        lastEliminated = player
        selectedPlayerID = nil

        if player.role == .pig {
            game.phase = .pigGuess
        } else {
            showEliminationResult = true
        }
    }

    /// Dismiss the announcement, then either end the game or begin the next
    /// round back at its discussion step.
    func continueAfterElimination() {
        lastEliminated = nil
        game.advanceAfterElimination()
    }

    /// Step back to the discussion screen for this round without eliminating anyone.
    func returnToDiscussion() {
        game.phase = .discussion
    }

    /// Abandon the current game and go back to setup.
    func restart() {
        game.phase = .setup
    }
}
