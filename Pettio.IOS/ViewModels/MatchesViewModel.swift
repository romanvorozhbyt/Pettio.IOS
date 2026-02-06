//
//  MatchesViewModel.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import Foundation
import SwiftData

@Observable
class MatchesViewModel {
    var matches: [Match] = []
    var sortedMatches: [Match] {
        matches.sorted { ($0.lastMessageAt ?? $0.createdAt) > ($1.lastMessageAt ?? $1.createdAt) }
    }
    
    init(matches: [Match] = []) {
        self.matches = matches
    }
    
    func loadMatches(myPetId: String, from descriptor: FetchDescriptor<Match>) {
        // This would be called with query results in the actual view
    }
    
    func removeMatch(_ match: Match, from modelContext: ModelContext) {
        modelContext.delete(match)
        matches.removeAll { $0.id == match.id }
    }
}
