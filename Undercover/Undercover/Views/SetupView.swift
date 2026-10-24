//
//  SetupView.swift
//  Undercover
//
//  Created by Gojo Satoru on 4/7/26.
//

import SwiftUI

struct SetupView: View {
    @State private var viewModel: SetupViewModel
    
    init(game: GameViewModel) {
        _viewModel = State(initialValue: SetupViewModel(game: game))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                playersSection
                specialRolesSection
                warningSection
            }
            .scrollContentBackground(.hidden)
            .background {
                ZStack {
                    Color.background.ignoresSafeArea()
                    SpotlightGradient(color: .theme, intensity: 0.28)
                        .ignoresSafeArea()
                }
            }
            .themedNavigationTitle(viewModel.strings.newGame)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    languageToggle
                }
            }
            .safeAreaInset(edge: .bottom) { startButton }
            .onChange(of: viewModel.maxUndercover) { _, _ in viewModel.clampUndercover() }
            .onChange(of: viewModel.maxPig) { _, _ in viewModel.clampPig() }
        }
    }
    
    // MARK: - Language Toggle (Fixed)
    private var languageToggle: some View {
        Button {
            viewModel.language = viewModel.language.toggled
            viewModel.game.language = viewModel.language  // sync if needed
        } label: {
            Text(viewModel.language.switchLabel)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .buttonStyle(ThemeButtonStyle(color: .theme, style: .icon))
    }
    
    // MARK: - Players
    private var playersSection: some View {
        Section {
            ForEach($viewModel.nameFields) { $field in
                let number = (viewModel.nameFields.firstIndex { $0.id == field.id } ?? 0) + 1
                
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.theme.opacity(0.15))
                            .frame(width: 30, height: 30)
                        Text("\(number)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.theme)
                    }
                    
                    TextField(viewModel.strings.playerPlaceholder(number), text: $field.text)
                        .textInputAutocapitalization(.words)
                    
                    if viewModel.nameFields.count > 3 {
                        Button {
                            withAnimation { viewModel.removePlayer(field) }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.yellow)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .swipeActions(edge: .trailing) {
                    if viewModel.nameFields.count > 3 {
                        Button(role: .destructive) {
                            withAnimation { viewModel.removePlayer(field) }
                        } label: {
                            Label("Xóa", systemImage: "trash")
                        }
                    }
                }
            }
            
            Button {
                withAnimation { viewModel.addPlayer() }
            } label: {
                Label(viewModel.strings.addPlayer, systemImage: "plus.circle.fill")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.yellow)
            }
        } header: {
            Text(viewModel.strings.playersHeader)
                .foregroundStyle(Color.textSecondary)
        } footer: {
            Text(viewModel.strings.playersFooter)
                .foregroundStyle(Color.textSecondary)
        }
    }
    
    // MARK: - Special roles
    private var specialRolesSection: some View {
        Section {
            roleStepperRow(title: viewModel.strings.undercoverRole, icon: "🕵️", color: .undercoverRole,
                           count: $viewModel.undercoverAgent, max: viewModel.maxUndercover)
            
            roleStepperRow(title: viewModel.strings.pigRole, icon: "🐷", color: .pigRole,
                           count: $viewModel.pig, max: viewModel.maxPig)
        } header: {
            Text(viewModel.strings.specialRolesHeader)
                .foregroundStyle(Color.textSecondary)
        } footer: {
            if viewModel.totalPlayers > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "person.3.fill")
                        .foregroundStyle(Color.yellow)
                    Text(viewModel.strings.civiliansRemaining(viewModel.civilianCount, viewModel.totalPlayers))
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
    }
    
    private func roleStepperRow(title: String, icon: String, color: Color,
                                count: Binding<Int>, max: Int) -> some View {
        HStack {
            Text(icon)
                .foregroundStyle(color)
            Text(title)
                .foregroundStyle(color)
            
            Spacer()
            
            Stepper("\(count.wrappedValue)", value: count, in: 0...max)
                .fixedSize()
                .labelsHidden()
                .foregroundStyle(color)
            
            Text("\(count.wrappedValue)")
                .fontWeight(.semibold)
                .frame(minWidth: 24, alignment: .trailing)
                .foregroundStyle(color)
        }
    }
    
    // MARK: - Warning
    @ViewBuilder
    private var warningSection: some View {
        if !viewModel.canStart && viewModel.totalPlayers >= 3 {
            Section {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                    Text(viewModel.strings.setupWarning)
                        .font(.footnote)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .listRowBackground(Color.yellow.opacity(0.08))
        }
    }
    
    // MARK: - Start Button
    private var startButton: some View {
        Button {
            viewModel.startGame()
        } label: {
            HStack {
                Image(systemName: "play.fill")
                Text(viewModel.strings.startGame)
            }
        }
        .buttonStyle(ThemeButtonStyle(color: .theme, style: .prominent))
        .disabled(!viewModel.canStart)
        .opacity(viewModel.canStart ? 1 : 0.4)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
}

#Preview {
    SetupView(game: GameViewModel())
}
