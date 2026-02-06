//
//  Match.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import Foundation
import SwiftData

@Model
final class Match {
    var id: String
    var myPetId: String
    var matchedPetId: String
    var matchedPet: Pet?
    var matchType: MatchType
    var createdAt: Date
    var lastMessageAt: Date?
    
    init(
        id: String = UUID().uuidString,
        myPetId: String,
        matchedPetId: String,
        matchedPet: Pet? = nil,
        matchType: MatchType,
        createdAt: Date = Date(),
        lastMessageAt: Date? = nil
    ) {
        self.id = id
        self.myPetId = myPetId
        self.matchedPetId = matchedPetId
        self.matchedPet = matchedPet
        self.matchType = matchType
        self.createdAt = createdAt
        self.lastMessageAt = lastMessageAt
    }
}

enum MatchType: String, Codable {
    case like = "Like"
    case superLike = "SuperLike"
}
