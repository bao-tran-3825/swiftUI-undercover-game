//
//  WordReader.swift
//  Undercover
//
//  Created by Gojo Satoru on 4/7/26.
//

import SwiftUI

struct Categories: Codable {
    let categories: [Category]
}

struct Category: Codable {
    let category: String
    let wordPairs: [PlayerWord]

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case wordPairs = "pairs"
    }
}

enum WordReader {
    static func load() -> [PlayerWord] {
        guard let url = Bundle.main.url(forResource: "bo-tu-undercover", withExtension: "json") else {
            print("bo-tu-undercover.json not found")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let database = try JSONDecoder().decode(Categories.self, from: data)
            return database.categories.flatMap { $0.wordPairs }
        } catch {
            print("Failed to load word pairs: \(error)")
            return []
        }
    }
}
