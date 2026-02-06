//
//  ContentView.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Discover", systemImage: "heart.fill")
                }
            
            MatchesView()
                .tabItem {
                    Label("Matches", systemImage: "star.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "pawprint.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.pink)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pet.self, Match.self, SwipeAction.self, configurations: config)
    
    return ContentView()
        .modelContainer(container)
}
