//
//  FeedViewModel.swift
//  Pettio.IOS
//
//  Created by Katerina Kaverina on 06.02.2026.
//

import Foundation
import SwiftData

@Observable
class FeedViewModel {
    var petCards: [Pet] = []
    var currentIndex: Int = 0
    var filteredBreeds: [String] = []
    var minAge: Int = 0
    var maxAge: Int = 15
    var selectedSize: PetSize? = nil
    var selectedPurpose: PetPurpose? = nil
    
    var currentPet: Pet? {
        guard currentIndex < petCards.count else { return nil }
        return petCards[currentIndex]
    }
    
    var remainingCards: Int {
        max(0, petCards.count - currentIndex)
    }
    
    init(pets: [Pet] = []) {
        self.petCards = pets.shuffled()
    }
    
    func swipeRight(myPetId: String, modelContext: ModelContext) {
        guard let pet = currentPet else { return }
        
        let swipeAction = SwipeAction(
            myPetId: myPetId,
            targetPetId: pet.id,
            action: .like
        )
        
        let match = Match(
            myPetId: myPetId,
            matchedPetId: pet.id,
            matchedPet: pet,
            matchType: .like
        )
        
        modelContext.insert(swipeAction)
        modelContext.insert(match)
        
        currentIndex += 1
    }
    
    func swipeLeft(myPetId: String, modelContext: ModelContext) {
        guard let pet = currentPet else { return }
        
        let swipeAction = SwipeAction(
            myPetId: myPetId,
            targetPetId: pet.id,
            action: .dislike
        )
        
        modelContext.insert(swipeAction)
        currentIndex += 1
    }
    
    func superLike(myPetId: String, modelContext: ModelContext) {
        guard let pet = currentPet else { return }
        
        let swipeAction = SwipeAction(
            myPetId: myPetId,
            targetPetId: pet.id,
            action: .superLike
        )
        
        let match = Match(
            myPetId: myPetId,
            matchedPetId: pet.id,
            matchedPet: pet,
            matchType: .superLike
        )
        
        modelContext.insert(swipeAction)
        modelContext.insert(match)
        
        currentIndex += 1
    }
    
    func applyFilters() {
        // Filter petCards based on selected filters
        var filtered = petCards
        
        if !filteredBreeds.isEmpty {
            filtered = filtered.filter { filteredBreeds.contains($0.breed) }
        }
        
        filtered = filtered.filter { $0.age >= minAge && $0.age <= maxAge }
        
        if let size = selectedSize {
            filtered = filtered.filter { $0.size == size }
        }
        
        if let purpose = selectedPurpose {
            filtered = filtered.filter { $0.purpose == purpose }
        }
        
        petCards = filtered
        currentIndex = 0
    }
    
    func reset() {
        currentIndex = 0
        petCards = petCards.shuffled()
    }
}
