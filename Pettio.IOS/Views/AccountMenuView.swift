//
//  AccountMenuView.swift
//  Pettio.IOS
//
//  Created by Катерина Каверина on 10.02.2026.
//

import SwiftUI
import SwiftData

struct AccountMenuView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @AppStorage("hasLinkedEmail") private var hasLinkedEmail = false
    
    @Query(filter: #Predicate<Pet> { pet in
        pet.isProfileOwner
    }) private var myPets: [Pet]
    
    @State private var showMenu = false
    @State private var showDeleteConfirm = false
    
    var myPet: Pet? {
        myPets.first
    }
    
    var body: some View {
        Menu {
            // View/Edit Profile
            if let pet = myPet {
                NavigationLink(destination: EditProfileView(pet: pet)) {
                    Label("Edit Profile", systemImage: "pencil")
                }
                
                NavigationLink(destination: ViewProfileView(pet: pet)) {
                    Label("View Profile", systemImage: "eye")
                }
            }
            
            Divider()
            
            // Account actions
            NavigationLink(destination: SettingsView()) {
                Label("Settings", systemImage: "gearshape.fill")
            }
            
            Button(role: .destructive, action: { showDeleteConfirm = true }) {
                Label("Delete Account", systemImage: "trash")
            }
        } label: {
            // Circle profile picture
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                
                if let pet = myPet {
                    if let profileImageData = pet.profileImageData, let uiImage = UIImage(data: profileImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    } else if let imageName = pet.imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                
                // Settings gear overlay
                Circle()
                    .fill(Color.pink)
                    .frame(width: 20, height: 20)
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
            .frame(width: 40, height: 40)
            .contentShape(Circle())
        }
        .alert("Delete Account", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove your profile, matches, and swipe history from this device.")
        }
    }
    
    private func deleteAccount() {
        do {
            let allPetsDescriptor = FetchDescriptor<Pet>()
            let allPets = try modelContext.fetch(allPetsDescriptor)
            let profiles = allPets.filter { $0.isProfileOwner || !$0.id.hasPrefix("pet_00") }
            profiles.forEach { modelContext.delete($0) }

            let matchDescriptor = FetchDescriptor<Match>()
            let matches = try modelContext.fetch(matchDescriptor)
            matches.forEach { modelContext.delete($0) }

            let swipeDescriptor = FetchDescriptor<SwipeAction>()
            let swipes = try modelContext.fetch(swipeDescriptor)
            swipes.forEach { modelContext.delete($0) }

            // Clear auth state
            AuthManager.shared.clearAuth()
            hasSeenWelcome = false
            hasLinkedEmail = false
        } catch {
            print("❌ Error deleting account: \(error)")
        }
    }
}

#Preview {
    AccountMenuView()
}

// Extracted view for profile details
struct ViewProfileView: View {
    let pet: Pet
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Profile header
                    VStack(alignment: .center, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                            
                            if let profileImageData = pet.profileImageData, let uiImage = UIImage(data: profileImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                            } else if let imageName = pet.imageName {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                            }
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
                }
                .padding()
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AccountMenuView()
}
