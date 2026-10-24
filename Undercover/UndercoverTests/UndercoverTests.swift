//
//  UndercoverTests.swift
//  UndercoverTests
//
//  Created by Gojo Satoru on 1/7/26.
//

import Testing
import Foundation
@testable import Undercover

struct UndercoverTests {

    // MARK: - Helpers

    /// Build a game with the given active-role counts, plus optional already-eliminated
    /// players to confirm they're excluded from win evaluation.
    private func makeGame(
        undercover: Int = 0,
        civilian: Int = 0,
        pig: Int = 0,
        eliminated: [Role] = []
    ) -> GameViewModel {
        let game = GameViewModel()
        var players: [Player] = []
        players += Array(repeating: Role.undercover, count: undercover).map {
            Player(name: "U", role: $0, word: "w")
        }
        players += Array(repeating: Role.civilian, count: civilian).map {
            Player(name: "C", role: $0, word: "w")
        }
        players += Array(repeating: Role.pig, count: pig).map {
            Player(name: "P", role: $0, word: nil)
        }
        players += eliminated.map {
            Player(name: "X", role: $0, word: "w", isEliminated: true)
        }
        game.players = players
        return game
    }

    // MARK: - Game continues

    @Test func gameContinuesWhenSpecialsStillOutnumbered() {
        let game = makeGame(undercover: 1, civilian: 3, pig: 1)
        #expect(game.checkWinCondition() == nil)
    }

    @Test func gameContinuesWhenPigRemainsButNotFinalTwo() {
        // Pig alive, no undercover, but 3 players left → nobody has won yet.
        let game = makeGame(civilian: 2, pig: 1)
        #expect(game.checkWinCondition() == nil)
    }

    // MARK: - Undercover wins

    @Test func undercoverWinsAtParityWithCivilians() {
        let game = makeGame(undercover: 2, civilian: 2)
        #expect(game.checkWinCondition() == .undercoverWins)
    }

    @Test func undercoverParityIgnoresPigCount() {
        // 2 undercover vs 2 civilians reaches parity even with a pig still around
        // (and more than two players left, so the pig hasn't won).
        let game = makeGame(undercover: 2, civilian: 2, pig: 1)
        #expect(game.checkWinCondition() == .undercoverWins)
    }

    // MARK: - Civilians win

    @Test func civiliansWinOnlyWhenAllSpecialsEliminated() {
        let game = makeGame(civilian: 3, eliminated: [.undercover, .pig])
        #expect(game.checkWinCondition() == .civiliansWin)
    }

    @Test func civiliansDoNotWinWhilePigSurvives() {
        // All undercovers gone but a pig is still active among >2 players.
        let game = makeGame(civilian: 3, pig: 1, eliminated: [.undercover])
        #expect(game.checkWinCondition() == nil)
    }

    // MARK: - Pig wins

    @Test func pigWinsWhenAmongFinalTwo() {
        let game = makeGame(civilian: 1, pig: 1)
        #expect(game.checkWinCondition() == .pigWins)
    }

    @Test func pigWinTakesPrecedenceOverUndercoverParity() {
        // Final two are one undercover + one pig: undercover parity also holds,
        // but the pig's final-two rule is checked first and wins.
        let game = makeGame(undercover: 1, pig: 1)
        #expect(game.checkWinCondition() == .pigWins)
    }

    // MARK: - eliminate / activePlayers

    @Test func eliminateMarksPlayerAndDropsFromActive() {
        let game = makeGame(undercover: 1, civilian: 2)
        let target = game.players[0]
        game.eliminate(playerID: target.id)

        #expect(game.players.first { $0.id == target.id }?.isEliminated == true)
        #expect(game.activePlayers.count == 2)
        #expect(!game.activePlayers.contains { $0.id == target.id })
    }

    @Test func eliminateWithUnknownIDDoesNothing() {
        let game = makeGame(civilian: 3)
        game.eliminate(playerID: UUID())
        #expect(game.activePlayers.count == 3)
    }
}
