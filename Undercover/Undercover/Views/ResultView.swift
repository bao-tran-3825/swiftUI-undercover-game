//
//  ResultView.swift
//  Undercover
//
//  Created by Gojo Satoru on 9/7/26.
//

import SwiftUI

struct ResultView: View {
    @State private var viewModel: ResultViewModel

    init(game: GameViewModel) {
        _viewModel = State(initialValue: ResultViewModel(game: game))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                outcomeBanner
                rosterList
            }
            .background(backgroundGradient)
            .themedNavigationTitle(viewModel.strings.resultTitle)
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) { playAgainButton }
        }
    }

    // MARK: - Outcome banner

    private var outcomeBanner: some View {
        VStack(spacing: 12) {
            bannerIcon

            Text(viewModel.title)
                .font(.stampedHeader(28))
                .textCase(.uppercase)
                .foregroundStyle(viewModel.accentColor)
                .multilineTextAlignment(.center)

            Text(viewModel.subtitle)
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal)
    }

    /// The undercover win uses the app icon (matching the start screen); every
    /// other outcome uses its themed SF Symbol.
    @ViewBuilder
    private var bannerIcon: some View {
        if viewModel.result == .undercoverWins, let icon = UIImage.appIcon {
            Image(uiImage: icon)
                .resizable()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        } else {
            Image(systemName: viewModel.result == .undercoverWins ? "theatermasks.fill" : viewModel.iconSystemName)
                .font(.system(size: 56))
                .foregroundStyle(viewModel.accentColor)
        }
    }

    // MARK: - Revealed roster

    private var rosterList: some View {
        List(viewModel.players) { player in
            HStack(spacing: 12) {
                Text(player.avatar)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(player.name)
                        .fontWeight(.semibold)
                        .strikethrough(player.isEliminated)
                        .foregroundStyle(player.isEliminated ? .secondary : .primary)
                    Text(viewModel.strings.roleName(player.role))
                        .font(.caption)
                        .foregroundStyle(player.role.tintColor)
                }

                Spacer()

                if let word = player.word {
                    Text(word)
                        .font(.caption)
                        .foregroundStyle(Color.black)
                        .lineLimit(1)
                }
            }
            .listRowBackground(
                player.isEliminated ? Color.red.opacity(0.35) : nil
            )
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    // MARK: - Play again

    private var playAgainButton: some View {
        Button {
            viewModel.playAgain()
        } label: {
            Label(viewModel.strings.playAgain, systemImage: "arrow.counterclockwise")
        }
        .buttonStyle(ThemeButtonStyle(color: viewModel.accentColor, style: .prominent))
        .padding()
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        ZStack {
            Color.background
            SpotlightGradient(color: viewModel.accentColor, intensity: 0.2)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    let game = GameViewModel()
    game.players = [
        Player(name: "Alice", role: .civilian, word: "Cà phê"),
        Player(name: "Bình", role: .undercover, word: "Trà sữa", isEliminated: true),
        Player(name: "Châu", role: .pig, word: nil)
    ]
    game.result = .civiliansWin
    return ResultView(game: game)
}
