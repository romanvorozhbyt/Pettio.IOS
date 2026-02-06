//
//  ProfileViewModel.swift
//  Pettio.IOS
//
//  Created by Katerina Kaverina on 06.02.2026.
//

import Foundation
import SwiftData

@Observable
class ProfileViewModel {
    var myPet: Pet?
    var isEditing: Bool = false
    
    init(pet: Pet? = nil) {
        self.myPet = pet
    }
    
    func updatePet(_ pet: Pet, in modelContext: ModelContext) {
        myPet = pet
        // SwiftData will automatically save changes
    }
    
    func savePet(_ pet: Pet, in modelContext: ModelContext) {
        if myPet == nil {
            modelContext.insert(pet)
        }
        myPet = pet
    }
}
