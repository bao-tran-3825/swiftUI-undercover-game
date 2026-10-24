//
//  GameViewModel.swift
//  Undercover
//
//  Created by Gojo Satoru on 4/7/26.
//

import SwiftUI

enum GameResult {
    case civiliansWin
    case undercoverWins
    case pigWins
}

@Observable
final class GameViewModel {
    var phase: GamePhase = .start
    var players: [Player] = []
    var currentRound: Int = 1
    var wordPairs: [PlayerWord] = WordReader.load()
    /// The outcome of the game, set once a win condition is met.
    var result: GameResult?
    /// The active UI language, toggled from the start screen.
    var language: AppLanguage = .vietnamese

    /// Localized strings for the current language.
    var strings: Strings { Strings(lang: language) }

    private func word(for role: Role, from pair: PlayerWord) -> String? {
        switch role {
        case .civilian:
            return pair.civilianWord
        case .undercover:
            return pair.undercoverWord
        case .pig:
            return strings.pigWord
        }
    }

    func startGame(playerNames: [String], undercoverCount: Int, pigCount: Int) {
        guard let wordPair = wordPairs.randomElement() else {
            print("Không có từ vựng trong bộ dữ liệu — kiểm tra bo-tu-undercover.json")
            return
        }

        let civilianCount = playerNames.count - undercoverCount - pigCount
        guard civilianCount >= 0 else {
            print("Không đủ lượng civilian để chơi")
            return
        }

        let shuffledNames = playerNames.shuffled()
        var assigned: [Player] = []
        // A shuffled avatar pool so civilians and undercovers get distinct emojis
        // without repeats (until the pool runs out).
        var avatarPool = PlayerAvatar.pool.shuffled()

        for (index, name) in shuffledNames.enumerated() {
            let role: Role
            if index < undercoverCount {
                role = .undercover
            } else if index < undercoverCount + pigCount {
                role = .pig
            } else {
                role = .civilian
            }
            let avatar: String
            if role == .pig {
                avatar = PlayerAvatar.pig
            } else {
                avatar = avatarPool.popLast() ?? PlayerAvatar.pool.randomElement() ?? "🙂"
            }
            assigned.append(Player(name: name, role: role,
                                   word: word(for: role, from: wordPair), avatar: avatar))
        }

        // Roles were assigned by index, so `assigned` is ordered undercover → pig → civilian.
        // Shuffle again so the reveal order doesn't give away who the special players are.
        players = assigned.shuffled()
        currentRound = 1
        phase = .reveal
    }

    /// Players still in the game (not voted out).
    var activePlayers: [Player] {
        players.filter { !$0.isEliminated }
    }

    /// Mark a player as eliminated by a vote.
    func eliminate(playerID: UUID) {
        guard let index = players.firstIndex(where: { $0.id == playerID }) else { return }
        players[index].isEliminated = true
    }

    /// Advance after an elimination is resolved: end the game if a side has won,
    /// otherwise begin the next round at its discussion step. Used by both the
    /// normal vote flow and the pig's wrong-guess path so the win condition is
    /// always re-checked before another round begins.
    func advanceAfterElimination() {
        if let outcome = checkWinCondition() {
            result = outcome
            phase = .result
        } else {
            currentRound += 1
            phase = .discussion
        }
    }

    /// Evaluate the win condition against the players still active.
    ///
    /// Precedence matters — checks run top to bottom:
    /// 1. Pig wins if it survives down to the final two players. Checked first so
    ///    it takes precedence over an undercover parity that also holds at two players.
    /// 2. Civilians win only when every special role (undercover *and* pig) is gone.
    /// 3. Undercover wins once it equals or outnumbers the remaining civilians.
    func checkWinCondition() -> GameResult? {
        let active = activePlayers
        let undercoverCount = active.filter { $0.role == .undercover }.count
        let civilianCount = active.filter { $0.role == .civilian }.count
        let pigCount = active.filter { $0.role == .pig }.count

        if pigCount > 0 && active.count <= 2 {
            return .pigWins
        }
        if undercoverCount == 0 && pigCount == 0 {
            return .civiliansWin
        }
        if undercoverCount >= civilianCount {
            return .undercoverWins
        }
        return nil
    }
}
