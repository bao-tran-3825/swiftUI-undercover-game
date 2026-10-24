//
//  Player.swift
//  Undercover
//
//  Created by Gojo Satoru on 3/7/26.
//

import SwiftUI

enum Role {
    case civilian
    case undercover
    case pig
}

extension Role {
    var tintColor: Color {
        switch self {
        case .civilian: return .civilianRole
        case .undercover: return .undercoverRole
        case .pig: return .pigRole
        }
    }

    /// Image shown alongside the word when a player's role is revealed.
    var image: ImageAsset {
        switch self {
        case .civilian: return .civilian
        case .undercover: return .undercover
        case .pig: return .pig
        }
    }

    /// Emoji used as a fallback when the role's image asset is missing.
    /// Civilian and undercover share the same smiley so the undercover isn't given away.
    var emoji: String {
        switch self {
        case .civilian, .undercover: return "😊"
        case .pig: return "🐷"
        }
    }
}

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var role: Role
    var word: String?
    var isEliminated: Bool = false
    /// A friendly avatar emoji shown on this player's reveal card. Civilians and
    /// undercovers draw from the same pool so the icon never hints at the role.
    var avatar: String = "🙂"
}

enum PlayerAvatar {
    /// Shared pool of 20+ friendly face emojis (civilian-themed) for civilians and undercovers.
    static let pool: [String] = [
        "😀", "😃", "😄", "😁", "😊", "🙂", "😉", "😌",
        "😍", "😎", "🤓", "🧐", "🤠", "🥳", "😇", "🤗",
        "😺", "🙃", "😋", "😜", "🤩", "🥸", "😏", "🤔",
        "🤐", "🤯", "😴", "😱", "😲", "😳", "😵", "😷",
        "🤒", "🤕", "🤣", "🤢", "🤣", "🤤", "🤧", "🥺",
        "🤡", "👻", "👹", "👿", "🤖", "🎃", "😈", "👺",
        "🤣", "🤤", "🤧", "🥺", "😴", "😳", "😵", "😷",
    ]

    /// The pig's fixed avatar.
    static let pig = "🐷"
}
