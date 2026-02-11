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
            
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
            
            // Register the URL scheme for OAuth callbacks
            registerGoogleURLScheme(reversedClientID)
        }
    }
    
    private func registerGoogleURLScheme(_ reversedClientID: String) {
        // URL scheme is already registered in Info.plist at build time
        // This is here for reference - the reversed client ID is used for Google OAuth callbacks
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Pet.self,
            Match.self,
            SwipeAction.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Seed database on first launch
                    let modelContext = sharedModelContainer.mainContext
                    SeedDataProvider.seedDatabaseIfNeeded(modelContext: modelContext)
                }
                .onOpenURL { url in
                    _ = GIDSignIn.sharedInstance.handle(url)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
