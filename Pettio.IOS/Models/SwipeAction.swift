//
//  SwipeAction.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import Foundation
import SwiftData

@Model
final class SwipeAction {
    var id: String
    var myPetId: String
    var targetPetId: String
    var action: ActionType
    var createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        myPetId: String,
        targetPetId: String,
        action: ActionType,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.myPetId = myPetId
        self.targetPetId = targetPetId
        self.action = action
        self.createdAt = createdAt
    }
}

enum ActionType: String, Codable {
    case like = "Like"
    case dislike = "Dislike"
    case superLike = "SuperLike"
}
