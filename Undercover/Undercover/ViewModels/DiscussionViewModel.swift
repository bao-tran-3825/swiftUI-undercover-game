//
//  DiscussionViewModel.swift
//  Undercover
//
//  Holds the state and flow for the discussion screen, keeping DiscussionView purely about layout.
//

import SwiftUI

@Observable
final class DiscussionViewModel {
    /// The shared game state that discussion advances round by round.
    let game: GameViewModel

    init(game: GameViewModel) {
        self.game = game
    }

    /// Localized strings for the current language.
    var strings: Strings { game.strings }

    // MARK: - Derived values

    /// The first two rounds are discussion only — elimination begins in round three.
    var isVotingAllowed: Bool { game.currentRound > 2 }

    var navigationTitle: String { strings.roundTitle(game.currentRound) }

    /// Label for the button that ends the discussion step.
    var discussionButtonTitle: String {
        isVotingAllowed ? strings.startVoting : strings.nextRound
    }

    // MARK: - Flow

    /// End the discussion step.
    /// - Rounds 1 → 2 are discussion only.
    /// - After the round-two discussion, voting begins immediately (round three has
    ///   no discussion of its own).
    /// - From round four on, each round's discussion is a prelude to that round's vote.
    func endDiscussion() {
        switch game.currentRound {
        case 1:
            game.currentRound = 2
        case 2:
            game.currentRound = 3
            game.phase = .voting
        default:
            game.phase = .voting
        }
    }

    /// Step back to the reveal screen.
    func returnToReveal() {
        game.phase = .reveal
    }

    /// Abandon the current game and go back to setup.
    func restart() {
        game.phase = .setup
    }
}
