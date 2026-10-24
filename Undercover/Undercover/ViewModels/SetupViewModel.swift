//
//  SetupViewModel.swift
//  Undercover
//
//  Holds all state and rules for the setup screen, keeping SetupView purely about layout.
//

import SwiftUI

/// A single editable player-name field, with a stable identity so SwiftUI can
/// safely add and delete rows without index-based crashes.
struct NameField: Identifiable {
    let id = UUID()
    var text: String = ""
}

@Observable
final class SetupViewModel {
    /// The shared game state this setup screen feeds into.
    let game: GameViewModel

    var nameFields: [NameField] = [NameField(), NameField(), NameField()]
    var undercoverAgent: Int = 1
    var pig: Int = 1

    init(game: GameViewModel) {
        self.game = game
    }

    /// Localized strings for the current language.
    var strings: Strings { game.strings }
    
    // MARK: - Easy access for SwiftUI
    
    // Add these two lines:
    var language: AppLanguage {
        get { game.language }
        set { game.language = newValue }
    }
    
    // Helper for strings (optional but helpful)
    var localized: Strings { strings }

    // MARK: - Derived values

    /// Names with surrounding whitespace removed that are non-empty.
    var validNames: [String] {
        nameFields
            .map { $0.text.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    var totalPlayers: Int { validNames.count }

    var maxUndercover: Int {
        guard totalPlayers > 0 else { return 1 }
        return max(1, (totalPlayers - 2 * pig) / 2)
    }

    var maxPig: Int {
        guard totalPlayers > 0 else { return 1 }
        return max(1, (totalPlayers - 2 * undercoverAgent) / 2)
    }

    var civilianCount: Int {
        max(0, totalPlayers - undercoverAgent - pig)
    }

    var canStart: Bool {
        let filledCount = validNames.count
        guard filledCount == nameFields.count, filledCount >= 3 else { return false }
        return undercoverAgent + pig <= civilianCount
    }

    // MARK: - Mutations

    func addPlayer() {
        nameFields.append(NameField())
    }

    func removePlayer(_ field: NameField) {
        nameFields.removeAll { $0.id == field.id }
    }

    /// Keep the undercover count within its currently allowed maximum.
    func clampUndercover() {
        undercoverAgent = min(undercoverAgent, maxUndercover)
    }

    /// Keep the pig count within its currently allowed maximum.
    func clampPig() {
        pig = min(pig, maxPig)
    }

    func startGame() {
        game.startGame(
            playerNames: validNames,
            undercoverCount: undercoverAgent,
            pigCount: pig
        )
    }
}
