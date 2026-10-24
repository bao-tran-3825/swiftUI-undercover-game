//
//  VotingView.swift
//  Undercover
//
//  Created by Gojo Satoru on 9/7/26.
//

import SwiftUI

struct VotingView: View {
    @State private var viewModel: VotingViewModel

    init(game: GameViewModel) {
        _viewModel = State(initialValue: VotingViewModel(game: game))
    }

    var body: some View {
        ZStack {
            NavigationStack {
                votingContent
                    .navigationBarTitleDisplayMode(.inline)
                    .themedNavigationTitle(viewModel.navigationTitle)
                    .gameNavigationBar(
                        strings: viewModel.strings,
                        onRestart: { viewModel.restart() },
                        onBack: { viewModel.returnToDiscussion() },
                        backTitle: viewModel.strings.backToDiscussionTitle,
                        backMessage: viewModel.strings.backToDiscussionMsg
                    )
                    .alert(viewModel.strings.confirmEliminationTitle, isPresented: $viewModel.showEliminationAlert) {
                        Button(viewModel.strings.cancel, role: .cancel) {}
                        Button(viewModel.strings.eliminate, role: .destructive) { viewModel.confirmElimination() }
                    } message: {
                        Text(viewModel.eliminationMessage)
                    }
            }

            if viewModel.showEliminationResult, let player = viewModel.lastEliminated {
                eliminationOverlay(for: player)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showEliminationResult)
    }

    // MARK: - Elimination announcement overlay

    private func eliminationOverlay(for player: Player) -> some View {
        let color = player.role.tintColor
        return ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text(viewModel.strings.eliminatedTitle)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(color.gradient, in: Capsule())

                Text(player.avatar)
                    .font(.system(size: 88))

                Text(player.name)
                    .font(.stampedHeader(24))
                    .textCase(.uppercase)

                Text(viewModel.strings.isRole(player.role))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)

                Button(viewModel.strings.continueButton) {
                    withAnimation { viewModel.continueAfterElimination() }
                }
                .buttonStyle(ThemeButtonStyle(color: color, style: .prominent))
                .padding(.top, 4)
            }
            .padding(28)
            .frame(maxWidth: 320)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.surface))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(color.opacity(0.6), lineWidth: 2)
            )
//            .noirShadow()
            .padding(40)
        }
    }

    // MARK: - Voting rounds

    private var votingContent: some View {
        VStack(spacing: 16) {
            Text(viewModel.strings.voteToEliminate)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.top, 8)

            candidateList

            Button(viewModel.strings.eliminatePlayer) {
                viewModel.requestElimination()
            }
            .buttonStyle(ThemeButtonStyle(color: .theme, style: .prominent))
            .disabled(!viewModel.canEliminate)
            .opacity(viewModel.canEliminate ? 1 : 0.5)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }

    private var candidateList: some View {
        List(viewModel.candidates) { player in
            Button {
                viewModel.select(player)
            } label: {
                HStack {
                    Text(player.name)
                        .foregroundStyle(.black)
                    Spacer()
                    if viewModel.isSelected(player) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.theme)
                    }
                }
                .contentShape(Rectangle())
            }
            .listRowBackground(
                viewModel.isSelected(player) ? Color.theme.opacity(0.12) : nil
            )
        }
        .listStyle(.insetGrouped)
    }
}

#Preview {
    VotingView(game: GameViewModel())
}
