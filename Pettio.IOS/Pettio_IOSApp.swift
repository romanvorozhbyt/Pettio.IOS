//
//  Pettio_IOSApp.swift
//  Pettio.IOS
//
//  Created by Катерина Каверина on 06.02.2026.
//

import SwiftUI
import SwiftData
import GoogleSignIn

@main
struct Pettio_IOSApp: App {
    init() {
        // Load Google Sign-In credentials from GoogleService-Info.plist
        if let googleServicePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let googleConfig = NSDictionary(contentsOfFile: googleServicePath),
           let clientID = googleConfig["CLIENT_ID"] as? String,
           let reversedClientID = googleConfig["REVERSED_CLIENT_ID"] as? String {
            
            // Use GIDConfiguration and assign to the shared instance (newer GoogleSignIn API)
            let gidConfig = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = gidConfig
            
            // Register the URL scheme for OAuth callbacks
            registerGoogleURLScheme(reversedClientID)
        }
    }
    
    private func registerGoogleURLScheme(_ reversedClientID: String) {
        // No-op: URL schemes are configured in Info.plist at build time.
        // Keep this helper for reference and tests.
    }

    // Shared ModelContainer for the app (use variadic model types)
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: Pet.self, Match.self, SwipeAction.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Seed database on first launch
                    let modelContext = ModelContext(sharedModelContainer)
                    SeedDataProvider.seedDatabaseIfNeeded(modelContext: modelContext)
                }
                .onOpenURL { url in
                    _ = GIDSignIn.sharedInstance.handle(url)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
