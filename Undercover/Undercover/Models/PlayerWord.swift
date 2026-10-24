//
//  PlayerWord.swift
//  Undercover
//
//  Created by Gojo Satoru on 3/7/26.
//

import SwiftUI

struct PlayerWord: Codable, Identifiable {
    let id: Int
    let civilianWord: String
    let undercoverWord: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case civilianWord = "civilian"
        case undercoverWord = "undercover"
    }
}
