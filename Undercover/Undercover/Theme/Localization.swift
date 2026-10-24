//
//  Localization.swift
//  Undercover
//
//  Centralized UI strings for the in-app Vietnamese/English toggle. Every
//  user-facing string lives here so both languages are maintained in one place.
//

import SwiftUI

enum AppLanguage: String {
    case vietnamese, english

    /// The other language — used by the toggle button.
    var toggled: AppLanguage { self == .vietnamese ? .english : .vietnamese }

    /// Short label shown on the toggle (the language you'd switch TO).
    var switchLabel: String { self == .vietnamese ? "EN" : "VI" }
}

/// All localized strings. Built from a language; each property/function returns
/// the right text. `s(_:_:)` picks Vietnamese or English.
struct Strings {
    let lang: AppLanguage

    private func s(_ vi: String, _ en: String) -> String {
        lang == .vietnamese ? vi : en
    }

    // MARK: - Common
    var cancel: String { s("Hủy", "Cancel") }
    var back: String { s("Quay lại", "Back") }
    var continueButton: String { s("Tiếp tục", "Continue") }

    // MARK: - Start
    var appTitle: String { "Undercover" }
    var play: String { s("Chơi", "Play") }

    // MARK: - Setup
    var newGame: String { s("Game mới", "New Game") }
    var playersHeader: String { s("Người chơi", "Players") }
    var playersFooter: String { s("Vuốt sang trái để xóa • Tối thiểu 3 người chơi",
                                  "Swipe left to delete • Minimum 3 players") }
    func playerPlaceholder(_ n: Int) -> String { s("Người chơi \(n)", "Player \(n)") }
    var addPlayer: String { s("Thêm người chơi", "Add player") }
    var specialRolesHeader: String { s("Người chơi đặc biệt", "Special roles") }
    func civiliansRemaining(_ civ: Int, _ total: Int) -> String {
        s("Còn lại \(civ) dân thường trong tổng số \(total) người",
          "\(civ) civilians remaining out of \(total) players")
    }
    var setupWarning: String {
        s("Số điệp viên và con heo phải nhỏ hơn hoặc bằng số dân thường.",
          "The number of undercovers and pigs must not exceed the number of civilians.")
    }
    var startGame: String { s("Bắt Đầu Game", "Start Game") }

    // MARK: - Reveal
    var noPlayers: String { s("Chưa có người chơi nào.", "No players yet.") }
    var goToSetupHint: String { s("Vui lòng bắt đầu game từ màn hình thiết lập.",
                                  "Please start the game from the setup screen.") }
    var goToSetup: String { s("Về màn hình thiết lập", "Go to setup") }
    var handPhoneTo: String { s("Đưa điện thoại cho", "Hand the phone to") }
    var confirmIdentity: String { s("Xác nhận bạn chính là người chơi này trước khi xem từ.",
                                    "Confirm you are this player before viewing the word.") }
    func iAm(_ name: String) -> String { s("Tôi là \(name)", "I am \(name)") }
    func passTo(_ name: String) -> String { s("Chuyển cho \(name)", "Pass to \(name)") }
    var hideAndPass: String { s("Ẩn & Chuyển", "Hide & Pass") }
    var tapToReveal: String { s("Chạm để xem", "Tap to reveal") }
    func playerProgress(_ i: Int, _ n: Int) -> String { s("Người chơi \(i)/\(n)", "Player \(i)/\(n)") }
    var pigWord: String { s("Chúc mừng! Bạn là 1 con heo. Cố mà đoán đi nhé 😉",
                            "Congrats! You're a pig. Try to guess 😉") }

    // MARK: - Voting
    func roundTitle(_ n: Int) -> String { s("Vòng \(n)", "Round \(n)") }
    func discussionTitle(_ n: Int) -> String { s("Vòng thảo luận \(n)", "Discussion round \(n)") }
    var discussionDescVoting: String {
        s("Mọi người mô tả từ của mình, rồi cùng bỏ phiếu loại một người.",
          "Everyone describes their word, then vote to eliminate someone.")
    }
    var discussionDescNoElim: String {
        s("Mọi người mô tả từ của mình. Chưa loại ai trong hai vòng đầu.",
          "Everyone describes their word. No one is eliminated in the first two rounds.")
    }
    var startVoting: String { s("Bắt đầu bỏ phiếu", "Start voting") }
    var nextRound: String { s("Vòng tiếp theo", "Next round") }
    var voteToEliminate: String { s("Bỏ phiếu loại một người chơi", "Vote to eliminate a player") }
    var eliminatePlayer: String { s("Loại người chơi", "Eliminate player") }
    var confirmEliminationTitle: String { s("Xác nhận loại", "Confirm elimination") }
    var eliminate: String { s("Loại", "Eliminate") }
    func eliminationConfirm(_ name: String) -> String {
        s("Loại \(name) khỏi vòng chơi này?", "Eliminate \(name) from this round?")
    }
    var eliminatedTitle: String { s("Người bị loại", "Eliminated") }
    func isRole(_ role: Role) -> String { s("là \(roleName(role))", "is \(roleName(role))") }
    var backToRevealTitle: String { s("Quay lại màn hình xem từ?", "Back to the word reveal?") }
    var backToRevealMsg: String { s("Bạn sẽ quay lại phần xem từ của người chơi.",
                                    "You'll return to the players' word reveal.") }
    var backToDiscussionTitle: String { s("Quay lại phần thảo luận?", "Back to the discussion?") }
    var backToDiscussionMsg: String { s("Bạn sẽ quay lại phần thảo luận của vòng này.",
                                        "You'll return to this round's discussion.") }
    var backToPreviousTitle: String { s("Quay lại người chơi trước?", "Back to the previous player?") }
    var backToPreviousMsg: String { s("Bạn sẽ quay lại lượt của người chơi trước mà không lộ từ.",
                                      "You'll return to the previous player's turn without revealing the word.") }

    // MARK: - Navigation bar (restart / back)
    var restartTitle: String { s("Chơi lại từ đầu?", "Restart from the beginning?") }
    var restart: String { s("Chơi lại", "Restart") }
    var restartMsg: String { s("Ván chơi hiện tại sẽ kết thúc và quay về màn hình thiết lập.",
                               "The current game will end and return to the setup screen.") }
    var backTitleDefault: String { s("Quay lại?", "Go back?") }
    var backMsgDefault: String { s("Bạn sẽ quay lại màn hình trước đó.",
                                   "You'll return to the previous screen.") }

    // MARK: - Result
    var resultTitle: String { s("Kết quả", "Result") }
    var playAgain: String { s("Chơi lại", "Play again") }
    var civiliansWinTitle: String { s("Dân thường chiến thắng!", "Civilians win!") }
    var undercoverWinTitle: String { s("Điệp viên chiến thắng!", "Undercover wins!") }
    var pigWinTitle: String { s("Con heo chiến thắng!", "Pig wins!") }
    var endTitle: String { s("Kết thúc", "Game over") }
    var civiliansWinSubtitle: String { s("Tất cả điệp viên đã bị khử.",
                                         "All undercovers have been eliminated.") }
    var undercoverWinSubtitle: String { s("Điệp viên đã hấp diêm dân thường.",
                                          "The undercovers have overwhelmed the civilians.") }
    var pigWinSubtitle: String { s("Con heo sống sót đến phút cuối.",
                                   "The pig survived to the end.") }
    var endSubtitle: String { s("Ván chơi đã kết thúc.", "The game has ended.") }

    // MARK: - Roles
    var undercoverRole: String { s("Điệp viên", "Undercover") }
    var pigRole: String { s("Con heo", "Pig") }
    var civilianRole: String { s("Dân thường", "Civilian") }
    func roleName(_ role: Role) -> String {
        switch role {
        case .civilian: return civilianRole
        case .undercover: return undercoverRole
        case .pig: return pigRole
        }
    }

    // MARK: - Pig guess
    var pigExposedTitle: String { s("Con heo bị lộ!", "The pig is exposed!") }
    var pigGuessDesc: String {
        s("Con heo có một cơ hội đoán từ của dân thường. Hãy nói to từ bạn đoán, rồi cả nhóm quyết định đúng hay sai.",
          "The pig gets one chance to guess the civilians' word. Say your guess out loud, then the group decides if it's right or wrong.")
    }
    var pigGuessCorrect: String { s("Heo thắng. Đồ thua cuộc 🐷", "Pig wins. Losers 🐷") }
    var pigGuessWrong: String { s("Đoán sai — Tiếp tục", "Wrong — Continue") }
}
