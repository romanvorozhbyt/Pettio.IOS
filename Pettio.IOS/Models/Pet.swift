//
//  Pet.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import Foundation
import SwiftData

@Model
final class Pet {
    var id: String
    var name: String
    var breed: String
    var age: Int // in years
    var size: PetSize
    var type: PetType
    var location: String
    var bio: String
    var imageURLs: [String]
    var imageName: String? // Local image name from Assets
    var profileImageData: Data? // User-uploaded profile picture
    var interests: [String] // e.g., ["playmate", "breeding", "adoption"]
    var purpose: PetPurpose
    var createdAt: Date
    var isProfileOwner: Bool = false // Mark user's own pet
    
    init(
        id: String = UUID().uuidString,
        name: String,
        breed: String,
        age: Int,
        size: PetSize,
        type: PetType,
        location: String,
        bio: String,
        imageURLs: [String] = [],
        imageName: String? = nil,
        profileImageData: Data? = nil,
        interests: [String] = [],
        purpose: PetPurpose = .playmate,
        createdAt: Date = Date(),
        isProfileOwner: Bool = false
    ) {
        self.id = id
        self.name = name
        self.breed = breed
        self.age = age
        self.size = size
        self.type = type
        self.location = location
        self.bio = bio
        self.imageURLs = imageURLs
        self.imageName = imageName
        self.profileImageData = profileImageData
        self.interests = interests
        self.purpose = purpose
        self.createdAt = createdAt
        self.isProfileOwner = isProfileOwner
    }
}

enum PetType: String, Codable, CaseIterable {
    case dog = "Dog"
    case cat = "Cat"
}

enum PetSize: String, Codable, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
}

enum PetPurpose: String, Codable, CaseIterable {
    case playmate = "Playmate"
    case breeding = "Breeding"
    case adoption = "Adoption"
    case friendship = "Friendship"
}
