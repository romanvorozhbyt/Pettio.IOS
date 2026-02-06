//
//  ProfileView.swift
//  Pettio.IOS
//
//  Created by Katerina Kaverina on 06.02.2026.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var pets: [Pet]
    @State private var isEditingProfile = false
    @State private var selectedPet: Pet?
    
    var myPet: Pet? {
        pets.first // In a real app, this would be the logged-in user's pet
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let pet = myPet ?? selectedPet {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Profile header
                            VStack(alignment: .center, spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                    
                                    Image(systemName: "pawprint.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 100, height: 100)
                                
                                VStack(spacing: 4) {
                                    Text("\(pet.name), \(pet.age)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    HStack(spacing: 12) {
                                        Label(pet.breed, systemImage: "pawprint.fill")
                                            .font(.caption)
                                        Label(pet.type.rawValue, systemImage: "pawprint.fill")
                                            .font(.caption)
                                    }
                                    .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Basic info
                            VStack(alignment: .leading, spacing: 12) {
                                InfoRow(label: "Breed", value: pet.breed)
                                InfoRow(label: "Type", value: pet.type.rawValue)
                                InfoRow(label: "Size", value: pet.size.rawValue)
                                InfoRow(label: "Age", value: "\(pet.age) years")
                                InfoRow(label: "Location", value: pet.location)
                                InfoRow(label: "Purpose", value: pet.purpose.rawValue)
                            }
                            
                            Divider()
                            
                            // Bio
                            VStack(alignment: .leading, spacing: 8) {
                                Text("About Me")
                                    .font(.headline)
                                Text(pet.bio)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            
                            // Interests
                            if !pet.interests.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Interests")
                                        .font(.headline)
                                    
                                    HStack(spacing: 8) {
                                        ForEach(pet.interests, id: \.self) { interest in
                                            Text(interest)
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.blue.opacity(0.1))
                                                .cornerRadius(12)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            
                            // Edit button
                            Button(action: { isEditingProfile = true }) {
                                Text("Edit Profile")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                            .padding(.vertical)
                        }
                        .padding()
                    }
                    .sheet(isPresented: $isEditingProfile) {
                        EditProfileView(pet: pet)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("Create Your Pet Profile")
                            .font(.headline)
                        
                        Text("Add your pet to get started swiping!")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: CreatePetView()) {
                            Text("Create Profile")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.pink)
                                .cornerRadius(12)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    let pet: Pet
    
    @State private var name: String = ""
    @State private var breed: String = ""
    @State private var age: Int = 1
    @State private var size: PetSize = .medium
    @State private var type: PetType = .dog
    @State private var location: String = ""
    @State private var bio: String = ""
    @State private var purpose: PetPurpose = .playmate
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $name)
                    TextField("Breed", text: $breed)
                    Stepper("Age: \(age)", value: $age, in: 0...30)
                    
                    Picker("Type", selection: $type) {
                        ForEach(PetType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Size", selection: $size) {
                        ForEach(PetSize.allCases, id: \.self) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                }
                
                Section("Location & Purpose") {
                    TextField("Location", text: $location)
                    
                    Picker("Purpose", selection: $purpose) {
                        ForEach(PetPurpose.allCases, id: \.self) { purpose in
                            Text(purpose.rawValue).tag(purpose)
                        }
                    }
                }
                
                Section("About") {
                    TextEditor(text: $bio)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        pet.name = name
                        pet.breed = breed
                        pet.age = age
                        pet.size = size
                        pet.type = type
                        pet.location = location
                        pet.bio = bio
                        pet.purpose = purpose
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                name = pet.name
                breed = pet.breed
                age = pet.age
                size = pet.size
                type = pet.type
                location = pet.location
                bio = pet.bio
                purpose = pet.purpose
            }
        }
    }
}

struct CreatePetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var breed: String = ""
    @State private var age: Int = 1
    @State private var size: PetSize = .medium
    @State private var type: PetType = .dog
    @State private var location: String = ""
    @State private var bio: String = ""
    @State private var purpose: PetPurpose = .playmate
    
    var isValid: Bool {
        !name.isEmpty && !breed.isEmpty && !location.isEmpty && !bio.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Pet Name", text: $name)
                    TextField("Breed", text: $breed)
                    Stepper("Age: \(age)", value: $age, in: 0...30)
                    
                    Picker("Type", selection: $type) {
                        ForEach(PetType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Size", selection: $size) {
                        ForEach(PetSize.allCases, id: \.self) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                }
                
                Section("Location & Purpose") {
                    TextField("Location", text: $location)
                    
                    Picker("Purpose", selection: $purpose) {
                        ForEach(PetPurpose.allCases, id: \.self) { purpose in
                            Text(purpose.rawValue).tag(purpose)
                        }
                    }
                }
                
                Section("About") {
                    TextEditor(text: $bio)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: createPet) {
                        Text("Create Profile")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }
                    .disabled(!isValid)
                }
            }
            .navigationTitle("Create Pet Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func createPet() {
        let newPet = Pet(
            name: name,
            breed: breed,
            age: age,
            size: size,
            type: type,
            location: location,
            bio: bio,
            imageURLs: [],
            interests: [],
            purpose: purpose
        )
        
        modelContext.insert(newPet)
        dismiss()
    }
}

#Preview {
    ProfileView()
}
