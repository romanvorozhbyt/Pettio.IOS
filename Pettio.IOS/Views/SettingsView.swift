//
//  SettingsView.swift
//  Pettio.IOS
//
//  Created by Katerina Kaverina on 06.02.2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var pushNotificationsEnabled = true
    @State private var matchNotificationsEnabled = true
    @State private var messageNotificationsEnabled = true
    @State private var privateProfile = false
    @State private var showAbout = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Notifications") {
                    Toggle("Push Notifications", isOn: $pushNotificationsEnabled)
                    Toggle("Match Notifications", isOn: $matchNotificationsEnabled)
                    Toggle("Message Notifications", isOn: $messageNotificationsEnabled)
                }
                
                Section("Privacy") {
                    Toggle("Private Profile", isOn: $privateProfile)
                    Text("When enabled, only matched pets can see your profile")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section("Discovery") {
                    NavigationLink(destination: DiscoveryPreferencesView()) {
                        Text("Discovery Preferences")
                    }
                }
                
                Section("Account") {
                    Button(role: .destructive) {
                        // Delete account action
                    } label: {
                        Text("Delete Account")
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: { showAbout = true }) {
                        Text("About Pettio")
                    }
                    
                    Button(action: {}) {
                        Text("Privacy Policy")
                    }
                    
                    Button(action: {}) {
                        Text("Terms of Service")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}

struct DiscoveryPreferencesView: View {
    @State private var maxDistance: Int = 50
    @State private var ageRange = 1...15
    @State private var selectedType: PetType? = nil
    
    var body: some View {
        Form {
            Section("Distance") {
                HStack {
                    Text("Max: \(maxDistance) km")
                    Slider(value: .init(get: { Double(maxDistance) }, 
                                       set: { maxDistance = Int($0) }), 
                          in: 1...100, step: 1)
                }
            }
            
            Section("Age Range") {
                HStack {
                    Text("Min: \(Int(ageRange.lowerBound)) years")
                    Slider(value: .init(get: { Double(ageRange.lowerBound) },
                                       set: { newValue in
                                           let clampedMin = min(Int(newValue), ageRange.upperBound)
                                           ageRange = clampedMin...ageRange.upperBound
                                       }),
                          in: 0...30, step: 1)
                }
                
                HStack {
                    Text("Max: \(Int(ageRange.upperBound)) years")
                    Slider(value: .init(get: { Double(ageRange.upperBound) },
                                       set: { newValue in
                                           let clampedMax = max(Int(newValue), ageRange.lowerBound)
                                           ageRange = ageRange.lowerBound...clampedMax
                                       }),
                          in: 0...30, step: 1)
                }
            }
            
            Section("Pet Type") {
                Picker("Show", selection: $selectedType) {
                    Text("Both").tag(Optional<PetType>(nil))
                    ForEach(PetType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(Optional(type))
                    }
                }
            }
        }
        .navigationTitle("Discovery Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.pink)
                        
                        Text("Pettio")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About Pettio")
                            .font(.headline)
                        
                        Text("Pettio is a social app that connects pet owners. Create profiles for your dogs and cats, swipe through an endless feed of other pets, and find potential matches based on breed, location, and interests.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeatureRow(title: "Pet Profiles", description: "Create and customize your pet's profile")
                            FeatureRow(title: "Endless Feed", description: "Swipe through pets in your area")
                            FeatureRow(title: "Matches", description: "Connect with compatible pets")
                            FeatureRow(title: "Customization", description: "Filter by breed, age, size, and purpose")
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("About Pettio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.pink)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    SettingsView()
}
