//
//  ThemeButtonStyle.swift
//  Undercover
//
//  Created by Gojo Satoru on 5/7/26.
//
//  Updated for the "Undercover" noir/interrogation-room aesthetic: dark charcoal
//  chrome, a single amber accent for CTAs, and distinct role colors so the
//  reveal/result screens read at a glance.
//

import SwiftUI

extension Color {
    /// The app's single main theme color. A cold-lit amber — the interrogation
    /// lamp — kept as the only warm, saturated color in the chrome so it reads
    /// as the "action" color against the charcoal background.
    static let theme = Color(red: 0.93, green: 0.76, blue: 0.42)

    /// Deep charcoal/near-black app background. Never pure black — keeps a hair
    /// of warmth so photography and shadows still read.
    static let background = Color(red: 0.07, green: 0.07, blue: 0.075)

    /// Slightly-raised surface for cards, rows and sheets — muted, not black,
    /// so content still separates from the background under the low light.
    static let surface = Color(red: 0.13, green: 0.13, blue: 0.14)

    /// A second, lighter surface step for nested/emphasized rows (e.g. the
    /// active player row, selected list items).
    static let surfaceRaised = Color(red: 0.18, green: 0.18, blue: 0.19)

    /// Hairline dividers and borders on dark surfaces.
    static let divider = Color.white.opacity(0.12)

    /// Primary text — an off-white, never full white, so it doesn't glare
    /// under the "spotlight" look.
    static let textPrimary = Color(red: 0.94, green: 0.94, blue: 0.92)

    /// Secondary/caption text — muted gray.
//    static let textSecondary = Color(red: 0.62, green: 0.62, blue: 0.64)
    static let textSecondary = theme.opacity(0.65)

    // MARK: - Role colors
    // Distinct, unambiguous hues for the three roles so a reveal or result
    // screen is identifiable at a glance, even to a player glancing over
    // someone's shoulder. Kept clear of `.theme` (amber) so the CTA never
    // gets mistaken for a role.

    /// Civilian — cold, steady steel blue. The "safe" / ordinary role.
    static let civilianRole = Color(red: 0.42, green: 0.58, blue: 0.72)

    /// Undercover — crimson red. Danger, suspicion, blood-on-the-carpet.
    static let undercoverRole = Color(red: 0.78, green: 0.16, blue: 0.20)

    /// Pig — a sickly, toxic yellow-green. Reads as "off," the odd one out.
    static let pigRole = Color(red: 0.62, green: 0.70, blue: 0.24)

    /// Looks up the themed color for a given `Role`.
    static func forRole(_ role: Role) -> Color {
        switch role {
        case .civilian: return .civilianRole
        case .undercover: return .undercoverRole
        case .pig: return .pigRole
        }
    }
}

extension Font {
    /// Stamped/redacted-document display type for titles and headers: a heavy
    /// monospaced cut, meant to be paired with `.textCase(.uppercase)` and
    /// extra `.tracking()` where it's used, like a case-file stamp.
    static func stampedHeader(_ size: CGFloat) -> Font {
        .system(size: size, weight: .heavy, design: .monospaced)
    }

    /// Clean, readable body copy — the system default face, kept plain so
    /// it doesn't compete with the stamped headers.
    static func bodyText(_ size: CGFloat = 16, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

extension View {
    /// The dramatic, single-source "interrogation lamp" shadow used behind
    /// cards and the reveal card: tight, dark and offset down, instead of a
    /// soft ambient shadow.
    func noirShadow() -> some View {
        self
            .shadow(color: .black.opacity(0.6), radius: 18, x: 0, y: 10)
            .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 1)
    }
}

/// A radial "spotlight" gradient — the single light source of an interrogation
/// room. Drop behind a reveal card or role portrait; darkens hard toward the
/// edges instead of fading evenly.
struct SpotlightGradient: View {
    var color: Color = .theme
    var intensity: Double = 0.35

    var body: some View {
        RadialGradient(
            colors: [color.opacity(intensity), .background.opacity(0)],
            center: .center,
            startRadius: 0,
            endRadius: 340
        )
        .allowsHitTesting(false)
    }
}

/// A stamped, redaction-bar look for hidden roles/words before they're
/// revealed — a solid black bar with a faint diagonal hazard texture, in
/// place of blurring or masking the text.
struct RedactedBar: View {
    var height: CGFloat = 22
    var cornerRadius: CGFloat = 2

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.black)
            .frame(height: height)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
            )
    }
}

/// A circular, theme-styled toolbar button showing an SF Symbol.
/// Shared by the reveal and discussion screens.
struct ThemeToolbarButton: View {
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
        }
        .buttonStyle(ThemeButtonStyle(color: .theme, style: .icon))
    }
}

/// Shared navigation chrome for the game screens: a leading "back" button and a
/// trailing "restart" button, each with its own confirmation alert. Written once
/// here so every screen gets identical behavior without repeating the toolbar and
/// alert code.
struct GameNavigationBar: ViewModifier {
    /// Localized strings, for the restart alert and cancel/back labels.
    var strings: Strings
    /// Confirmed-restart handler. Restart always returns to the setup screen.
    var onRestart: () -> Void
    /// Confirmed-back handler. If nil, no back button is shown.
    var onBack: (() -> Void)?
    /// Lets a screen hide the back button while keeping the same handler
    /// (e.g. the reveal screen hides it on the first player).
    var showBack: Bool

    /// Back-alert text; nil falls back to the localized defaults.
    var backTitle: String?
    var backMessage: String?
    var backConfirmLabel: String?

    @State private var showBackAlert = false
    @State private var showRestartAlert = false

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if onBack != nil && showBack {
                        ThemeToolbarButton(systemImage: "chevron.left") { showBackAlert = true }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ThemeToolbarButton(systemImage: "arrow.counterclockwise") { showRestartAlert = true }
                }
            }
            .alert(backTitle ?? strings.backTitleDefault, isPresented: $showBackAlert) {
                Button(strings.cancel, role: .cancel) {}
                Button(backConfirmLabel ?? strings.back) { onBack?() }
            } message: {
                Text(backMessage ?? strings.backMsgDefault)
            }
            .alert(strings.restartTitle, isPresented: $showRestartAlert) {
                Button(strings.cancel, role: .cancel) {}
                Button(strings.restart, role: .destructive) { onRestart() }
            } message: {
                Text(strings.restartMsg)
            }
    }
}

extension View {
    /// Adds the shared game back/restart toolbar buttons and their confirmation alerts.
    /// Pass `onBack: nil` for screens that have no previous step.
    func gameNavigationBar(
        strings: Strings,
        onRestart: @escaping () -> Void,
        onBack: (() -> Void)? = nil,
        showBack: Bool = true,
        backTitle: String? = nil,
        backMessage: String? = nil,
        backConfirmLabel: String? = nil
    ) -> some View {
        modifier(GameNavigationBar(
            strings: strings,
            onRestart: onRestart,
            onBack: onBack,
            showBack: showBack,
            backTitle: backTitle,
            backMessage: backMessage,
            backConfirmLabel: backConfirmLabel
        ))
    }
}

struct ThemeButtonStyle: ButtonStyle {
    enum Style {
        case prominent   // solid filled background, for primary actions
        case outline     // tinted border, no fill, for secondary actions
        case icon        // circular tap target, for toolbar icons
    }

    var color: Color = .theme
    var style: Style = .prominent

    func makeBody(configuration: Configuration) -> some View {
        switch style {
        case .prominent:
            configuration.label
                .font(.bodyText(16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(color)
                .foregroundStyle(Color.background)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .shadow(color: .black.opacity(configuration.isPressed ? 0.15 : 0.5), radius: configuration.isPressed ? 3 : 10, x: 0, y: configuration.isPressed ? 1 : 6)
                .opacity(configuration.isPressed ? 0.85 : 1)
                .scaleEffect(configuration.isPressed ? 0.98 : 1)

        case .outline:
            configuration.label
                .font(.bodyText(16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.surface.opacity(configuration.isPressed ? 0.6 : 1))
                .foregroundStyle(color)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(color.opacity(0.6), lineWidth: 1.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 4))

        case .icon:
            configuration.label
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 36, height: 36)
                .background(Color.surface.opacity(configuration.isPressed ? 0.9 : 0.7))
                .clipShape(Circle())
        }
    }
}

struct ThemedNavigationTitle: ViewModifier {
    let title: String

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Color.theme)
                }
            }
    }
}

extension View {
    /// Applies the app-wide themed nav title. Use in place of `.navigationTitle`.
    func themedNavigationTitle(_ title: String) -> some View {
        modifier(ThemedNavigationTitle(title: title))
    }
}
