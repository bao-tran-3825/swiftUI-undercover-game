//
//  StartView.swift
//  Undercover
//
//  The opening screen: the app icon on a theme background with a button to start.
//

import SwiftUI

struct StartView: View {
    let game: GameViewModel
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            SpotlightGradient(color: .theme, intensity: 0.28)

            VStack(spacing: 40) {
                Spacer(minLength: 60)
                
                appIcon
                
                Text(game.strings.appTitle)
//                    .font(.stampedHeader(42))
                    .font(Font.stampedHeader(42).weight(.semibold))
                    .textCase(.uppercase)
//                    .tracking(2)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    game.phase = .setup
                } label: {
                    Label(game.strings.play, systemImage: "play.fill")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .buttonStyle(ThemeButtonStyle(color: .theme, style: .prominent))
                .frame(maxWidth: 280)
                .padding(.horizontal, 32)
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
    }
    
    // MARK: - App Icon (Fixed)
    @ViewBuilder
    private var appIcon: some View {
        Group {
            if let icon = UIImage(named: "AppIcon") ?? UIImage.appIcon {
                Image(uiImage: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .shadow(color: .black.opacity(0.25), radius: 20, y: 10)
            } else {
                Image(systemName: "theatermasks.fill")
                    .font(.system(size: 110))
                    .foregroundStyle(Color.theme)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
            }
        }
    }
    
}

#Preview {
    StartView(game: GameViewModel())
}
