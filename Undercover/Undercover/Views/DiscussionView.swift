//
//  DiscussionView.swift
//  Undercover
//
//  The discussion step shown at the start of each round, before voting begins.
//

import SwiftUI

struct DiscussionView: View {
    @State private var viewModel: DiscussionViewModel

    init(game: GameViewModel) {
        _viewModel = State(initialValue: DiscussionViewModel(game: game))
    }

    var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .themedNavigationTitle(viewModel.navigationTitle)
                .gameNavigationBar(
                    strings: viewModel.strings,
                    onRestart: { viewModel.restart() },
                    onBack: { viewModel.returnToReveal() },
                    backTitle: viewModel.strings.backToRevealTitle,
                    backMessage: viewModel.strings.backToRevealMsg
                )
        }
    }

    // MARK: - Discussion rounds

    private var content: some View {
        ZStack {
            discussionBackground

            VStack {
                Spacer()

                // Text sits on a material card so it stays legible over the artwork.
                VStack(spacing: 16) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Color.theme)

                    Text(viewModel.strings.discussionTitle(viewModel.game.currentRound))
                        .font(.stampedHeader(22))
                        .textCase(.uppercase)
                        .multilineTextAlignment(.center)

                    Text(viewModel.isVotingAllowed
                         ? viewModel.strings.discussionDescVoting
                         : viewModel.strings.discussionDescNoElim)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(28)
                .frame(maxWidth: 360)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 6))
                .noirShadow()
                .padding(.horizontal, 24)

                Spacer()

                Button(viewModel.discussionButtonTitle) {
                    viewModel.endDiscussion()
                }
                .buttonStyle(ThemeButtonStyle(color: .theme, style: .prominent))
                .frame(maxWidth: 420)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
    }

    /// Full-screen artwork behind the discussion step, with a light scrim
    /// (falls back to the theme gradient if the image is missing).
    private var discussionBackground: some View {
        Group {
            if ImageAsset.discussionBackground.exists {
                ImageAsset.discussionBackground.image
                    .resizable()
                    .scaledToFill()
            } else {
                LinearGradient(
                    colors: [Color.theme.opacity(0.15), Color.theme.opacity(0.08)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
        .overlay(Color.background.opacity(0.55).ignoresSafeArea())
    }
}

#Preview {
    DiscussionView(game: GameViewModel())
}
