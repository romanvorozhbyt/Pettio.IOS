//
//  SeedDataProvider.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 07.02.2026.
//

import Foundation
import SwiftData

struct SeedDataProvider {
    static func createSamplePets() -> [Pet] {
        [
            Pet(
                id: "pet_001",
                name: "Max",
                breed: "Golden Retriever",
                age: 3,
                size: .large,
                type: .dog,
                location: "San Francisco, CA",
                bio: "Friendly golden retriever who loves playing fetch and swimming! Always up for adventure.",
                imageURLs: [],
                imageName: "2",
                interests: ["playmate", "adventure"],
                purpose: .playmate,
                isProfileOwner: false
            ),
            Pet(
                id: "pet_002",
                name: "Luna",
                breed: "Husky",
                age: 2,
                size: .large,
                type: .dog,
                location: "Seattle, WA",
                bio: "Beautiful husky with striking blue eyes. Love hiking and outdoor activities!",
                imageURLs: [],
                imageName: "3",
                interests: ["hiking", "sports"],
                purpose: .playmate,
                isProfileOwner: false
            ),
            Pet(
                id: "pet_003",
                name: "Bella",
                breed: "French Bulldog",
                age: 4,
                size: .small,
                type: .dog,
                location: "Los Angeles, CA",
                bio: "Cute and cuddly Frenchie. Perfect for calm meetups and relaxing together.",
                imageURLs: [],
                imageName: "4",
                interests: ["cuddles", "playdates"],
                purpose: .friendship,
                isProfileOwner: false
            ),
            Pet(
                id: "pet_004",
                name: "Charlie",
                breed: "Labrador",
                age: 5,
                size: .large,
                type: .dog,
                location: "Austin, TX",
                bio: "Energetic lab who loves everyone! Great with other dogs and always ready to play.",
                imageURLs: [],
                imageName: "5",
                interests: ["sports", "group play"],
                purpose: .playmate,
                isProfileOwner: false
            ),
            Pet(
                id: "pet_005",
                name: "Whiskers",
                breed: "Persian Cat",
                age: 3,
                size: .small,
                type: .cat,
                location: "New York, NY",
                bio: "Elegant and affectionate Persian cat. Enjoys quiet time and gentle play.",
                imageURLs: [],
                imageName: "6",
                interests: ["cuddles", "indoor play"],
                purpose: .friendship,
                isProfileOwner: false
            ),
            Pet(
                id: "pet_006",
                name: "Shadow",
                breed: "German Shepherd",
                age: 6,
                size: .large,
                type: .dog,
                location: "Denver, CO",
                bio: "Intelligent and loyal German Shepherd. Looking for an active match!",
                imageURLs: [],
                imageName: "7",
                interests: ["training", "adventure"],
                purpose: .playmate,
                isProfileOwner: false
            ),
            Pet(
                id: "pet_007",
                name: "Mittens",
                breed: "Tabby Cat",
                age: 2,
                size: .small,
                type: .cat,
                location: "Portland, OR",
                bio: "Playful tabby kitten with tons of energy! Love interactive toys and climbing.",
                imageURLs: [],
                imageName: "8",
                interests: ["toys", "climbing"],
                purpose: .playmate,
                isProfileOwner: false
            ),
            Pet(
                id: "pet_008",
                name: "Rocky",
                breed: "Bernese Mountain Dog",
                age: 4,
                size: .large,
                type: .dog,
                location: "Boulder, CO",
                bio: "Gentle giant who loves outdoor activities. Perfect hiking companion!",
                imageURLs: [],
                imageName: "1",
                interests: ["hiking", "outdoor"],
                purpose: .playmate,
                isProfileOwner: false
            )
        ]
    }
    
    static func seedDatabaseIfNeeded(modelContext: ModelContext) {
        // Check if database is already seeded by looking for specific test pet IDs
        let descriptor = FetchDescriptor<Pet>(predicate: #Predicate<Pet> { pet in
            pet.id == "pet_001" || pet.id == "pet_002"
        })
        
        do {
            let existingPets = try modelContext.fetch(descriptor)
            
            if existingPets.isEmpty {
                print("📦 Seeding database with sample pets...")
                
                // Database is empty, seed with sample data
                let samplePets = createSamplePets()
                for pet in samplePets {
                    modelContext.insert(pet)
                }
                
                // Save changes
                try modelContext.save()
                print("✅ Database seeded with \(samplePets.count) sample pets")
            } else {
                print("✓ Database already contains sample pets")
            }
            
            // Debug: Print all pets in database
            let allPetsDescriptor = FetchDescriptor<Pet>()
            let allPets = try modelContext.fetch(allPetsDescriptor)
            print("📊 Total pets in database: \(allPets.count)")
            print("   - Profile owners: \(allPets.filter { $0.isProfileOwner }.count)")
            print("   - Discoverable pets: \(allPets.filter { !$0.isProfileOwner }.count)")
        } catch {
            print("❌ Error seeding database: \(error)")
        }
    }
}
