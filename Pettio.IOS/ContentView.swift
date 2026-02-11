//
//  ContentView.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(filter: #Predicate<Pet> { pet in
        pet.isProfileOwner
    }) private var myPets: [Pet]
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @AppStorage("hasLinkedEmail") private var hasLinkedEmail = false

    var body: some View {
        if myPets.isEmpty {
            OnboardingFlowView(
                hasSeenWelcome: $hasSeenWelcome,
                hasLinkedEmail: $hasLinkedEmail
            )
        } else {
            NavigationStack {
                TabView {
                    FeedView()
                        .tabItem {
                            Label("Discover", systemImage: "heart.fill")
                        }
                    
                    MatchesView()
                        .tabItem {
                            Label("Matches", systemImage: "star.fill")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                }
                .tint(.pink)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        AccountMenuView()
                    }
                }
                .navigationTitle("Pettio")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pet.self, Match.self, SwipeAction.self, configurations: config)
    
    ContentView()
        .modelContainer(container)
}
