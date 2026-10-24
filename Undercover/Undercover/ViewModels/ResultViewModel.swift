//
//  ResultViewModel.swift
//  Undercover
//
//  Holds the outcome presentation for the result screen, keeping ResultView purely about layout.
//

import SwiftUI

@Observable
final class ResultViewModel {
    /// The shared game state holding the final outcome and player roster.
    let game: GameViewModel

    init(game: GameViewModel) {
        self.game = game
    }

    /// Localized strings for the current language.
    var strings: Strings { game.strings }

    // MARK: - Derived values

    var result: GameResult? { game.result }

    /// All players, revealed with their true roles now that the game is over.
    var players: [Player] { game.players }

    var title: String {
        switch result {
        case .civiliansWin: return strings.civiliansWinTitle
        case .undercoverWins: return strings.undercoverWinTitle
        case .pigWins: return strings.pigWinTitle
        case nil: return strings.endTitle
        }
    }

    var subtitle: String {
        switch result {
        case .civiliansWin: return strings.civiliansWinSubtitle
        case .undercoverWins: return strings.undercoverWinSubtitle
        case .pigWins: return strings.pigWinSubtitle
        case nil: return strings.endSubtitle
        }
    }

    /// Color and icon reflect the winning side, reusing the role tint palette.
    var accentColor: Color {
        switch result {
        case .undercoverWins: return .orange
        case .pigWins: return .pink
        case .civiliansWin, nil: return .theme
        }
    }

    var iconSystemName: String {
        switch result {
        case .civiliansWin: return "person.3.fill"
        case .undercoverWins: return "eye.trianglebadge.exclamationmark.fill"
        case .pigWins: return "crown.fill"
        case nil: return "flag.checkered"
        }
    }

    // MARK: - Flow

    /// Start over: clear the outcome and return to the setup screen.
    func playAgain() {
        game.result = nil
        game.phase = .setup
    }
}
