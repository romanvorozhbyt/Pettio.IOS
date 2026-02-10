//
//  FeedViewModel.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import Foundation
import SwiftData

@Observable
class FeedViewModel {
    var petCards: [Pet] = []
    var allPets: [Pet] = [] // Store original unfiltered list
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
        if pets.isEmpty {
            self.petCards = []
        } else {
            self.petCards = pets.shuffled()
        }
    }
    
    func loadPets(from modelContext: ModelContext) {
        do {
            // Fetch all pets that are not the profile owner
            var descriptor = FetchDescriptor<Pet>(predicate: #Predicate<Pet> { pet in
                pet.isProfileOwner == false
            })
            descriptor.fetchLimit = 100
            
            let fetchedPets = try modelContext.fetch(descriptor)
            print("🔍 FeedViewModel: Loaded \(fetchedPets.count) discoverable pets")
            
            self.allPets = fetchedPets // Store original list
            self.petCards = fetchedPets.shuffled()
            self.currentIndex = 0
        } catch {
            print("❌ Error loading pets: \(error)")
            self.allPets = []
            self.petCards = []
        }
    }
    
    func swipeRight(myPetId: String, modelContext: ModelContext) {
        guard let pet = currentPet else { return }
        
        let swipeAction = SwipeAction(
            myPetId: myPetId,
            targetPetId: pet.id,
            action: .like
        )
        modelContext.insert(swipeAction)
        
        // Check if match already exists
        let petId = pet.id
        let matchDescriptor = FetchDescriptor<Match>(
            predicate: #Predicate<Match> { match in
                match.matchedPetId == petId
            }
        )
        
        do {
            let existingMatches = try modelContext.fetch(matchDescriptor)
            if existingMatches.isEmpty {
                // Only create match if it doesn't exist
                let match = Match(
                    myPetId: myPetId,
                    matchedPetId: pet.id,
                    matchedPet: pet,
                    matchType: .like
                )
                modelContext.insert(match)
                print("✅ New match created with \(pet.name)")
            } else {
                print("ℹ️ Match with \(pet.name) already exists")
            }
        } catch {
            print("❌ Error checking for existing match: \(error)")
        }
        
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
        modelContext.insert(swipeAction)
        
        // Check if match already exists
        let petId = pet.id
        let matchDescriptor = FetchDescriptor<Match>(
            predicate: #Predicate<Match> { match in
                match.matchedPetId == petId
            }
        )
        
        do {
            let existingMatches = try modelContext.fetch(matchDescriptor)
            if existingMatches.isEmpty {
                // Only create match if it doesn't exist
                let match = Match(
                    myPetId: myPetId,
                    matchedPetId: pet.id,
                    matchedPet: pet,
                    matchType: .superLike
                )
                modelContext.insert(match)
                print("⭐ New super like match created with \(pet.name)")
            } else {
                print("ℹ️ Match with \(pet.name) already exists")
            }
        } catch {
            print("❌ Error checking for existing match: \(error)")
        }
        
        currentIndex += 1
    }
    
    func applyFilters() {
        // Always filter from the original unfiltered list
        var filtered = allPets
        
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
        
        petCards = filtered.shuffled()
        currentIndex = 0
        
        print("🔍 Filter applied: \(filtered.count) pets match criteria")
    }
    
    func reset() {
        currentIndex = 0
        petCards = allPets.shuffled()
    }
}
