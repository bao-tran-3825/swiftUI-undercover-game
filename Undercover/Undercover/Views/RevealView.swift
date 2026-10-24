//
//  RevealView.swift
//  Undercover
//
//  Created by Gojo Satoru on 5/7/26.
//

import SwiftUI

struct RevealView: View {
    @State private var viewModel: RevealViewModel

    /// The card keeps this portrait ratio and is sized from the available space (see `revealCardView`).
    private let cardAspectRatio: CGFloat = 3.0 / 4.0

    init(game: GameViewModel) {
        _viewModel = State(initialValue: RevealViewModel(game: game))
    }

    var body: some View {
        NavigationStack {
            content
        }
    }

    private var content: some View {
        GeometryReader { proxy in
            ZStack {
                backgroundGradient

                VStack(spacing: 24) {
                    if viewModel.players.isEmpty {
                        emptyStateView
                    } else if let player = viewModel.currentPlayer {
                        if !viewModel.hasConfirmedTurn {
                            confirmationView(for: player)
                        } else {
                            revealCardView(for: player, in: proxy.size)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
        .themedNavigationTitle(viewModel.navigationTitle)
        .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.navigationTitle)
                        .font(.headline)
                        .foregroundStyle(Color.theme)
                }
            }
        .navigationBarTitleDisplayMode(.inline)
        .gameNavigationBar(
            strings: viewModel.strings,
            onRestart: { viewModel.returnToSetup() },
            onBack: { withAnimation { viewModel.goToPreviousPlayer() } },
            showBack: !viewModel.isFirstPlayer,
            backTitle: viewModel.strings.backToPreviousTitle,
            backMessage: viewModel.strings.backToPreviousMsg
        )
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        ZStack {
            Color.background
            SpotlightGradient(color: viewModel.backgroundTint, intensity: 0.22)
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.3), value: viewModel.backgroundTint)
    }

    // MARK: - Empty state guard

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(.yellow)
            Text(viewModel.strings.noPlayers)
                .font(.headline)
            Text(viewModel.strings.goToSetupHint)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(viewModel.strings.goToSetup) {
                viewModel.returnToSetup()
            }
            .buttonStyle(ThemeButtonStyle(color: .theme, style: .prominent))
        }
    }

    // MARK: - Confirmation step

    private func confirmationView(for player: Player) -> some View {
        VStack(spacing: 20) {
            Spacer()

            let circleSize: CGFloat = 200
            Circle()
                .fill(Color.theme.opacity(0.15))
                .frame(width: circleSize, height: circleSize)
                .overlay(
                    Image(systemName: "hand.raised.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: circleSize * 0.4, height: circleSize * 0.4)
                        .foregroundStyle(Color.theme)
                )

            Text(viewModel.strings.handPhoneTo)
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)

            Text(player.name)
                .font(.stampedHeader(32))
                .textCase(.uppercase)
                .foregroundStyle(Color.theme)

            Text(viewModel.strings.confirmIdentity)
                .font(.footnote)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()

            primaryButton(viewModel.strings.iAm(player.name), icon: "checkmark.circle.fill", color: .theme) {
                withAnimation { viewModel.confirmTurn() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Reveal card with 3D flip

    private func revealCardView(for player: Player, in size: CGSize) -> some View {
        VStack(spacing: 28) {
            Spacer()

            Text(viewModel.strings.passTo(player.name))
                .font(.headline)
                .foregroundStyle(Color.textSecondary)

            ZStack {
                cardBackFace
                    .opacity(viewModel.isWordVisible ? 0 : 1)

                cardFrontFace(word: player.word ?? "???", avatar: player.avatar, color: viewModel.revealColor(for: player))
                    .opacity(viewModel.isWordVisible ? 1 : 0)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
            .rotation3DEffect(
                .degrees(viewModel.flipRotation),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.4
            )
            .aspectRatio(cardAspectRatio, contentMode: .fit)
            .frame(maxWidth: size.width * 0.6, maxHeight: size.height * 0.55)
            .noirShadow()
            .contentShape(Rectangle())
            .onTapGesture {
                if !viewModel.isWordVisible {
                    viewModel.reveal()
                }
            }

            Spacer()

            if viewModel.isWordVisible {
                primaryButton(viewModel.strings.hideAndPass, icon: "arrow.right.circle.fill",
                              color: viewModel.revealColor(for: player)) {
                    viewModel.advance()
                }
            } else {
                primaryButton(viewModel.strings.tapToReveal, icon: "eye.fill", color: .theme, style: .outline) {
                    viewModel.reveal()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// A themed primary button with an icon, sized consistently across the reveal screens.
    private func primaryButton(_ title: String, icon: String, color: Color,
                               style: ThemeButtonStyle.Style = .prominent,
                               action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
        }
        .buttonStyle(ThemeButtonStyle(color: color, style: style))
        .frame(maxWidth: 420)
    }

    // MARK: - Card faces

    /// Card back — shown before the word is revealed.
    /// Replace "card-back" with your own image asset name once you add it to Assets.xcassets.
    private var cardBackFace: some View {
        ImageAsset.cardBack.image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Card front — shown after reveal: the player's avatar emoji above the word.
    private func cardFrontFace(word: String, avatar: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.surface)
            .overlay(
                VStack(spacing: 16) {
                    Text(avatar)
                        .font(.system(size: 100))
                        .frame(maxHeight: .infinity)
                    Text(word)
                        .font(.stampedHeader(28))
                        .foregroundStyle(color)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        .lineLimit(4)
                }
                .padding(24)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(color.opacity(0.6), lineWidth: 2)
            )
            .noirShadow()
    }
}

#Preview("Confirmation") {
    let game = GameViewModel()
    game.players = [Player(name: "Alice", role: .civilian, word: "Cà phê")]
    return RevealView(game: game)
}
