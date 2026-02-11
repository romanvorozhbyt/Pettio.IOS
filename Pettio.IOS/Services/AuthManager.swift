//
//  AuthManager.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 10.02.2026.
//

import Foundation
import GoogleSignIn
import UIKit

enum AuthError: LocalizedError {
    case missingClientID
    case missingEmail
    case invalidEmail
    case weakPassword
    case noRootViewController

    var errorDescription: String? {
        switch self {
        case .missingClientID:
            return "Missing Google Client ID."
        case .missingEmail:
            return "Email not found."
        case .invalidEmail:
            return "Please enter a valid email."
        case .weakPassword:
            return "Password must be at least 6 characters."
        case .noRootViewController:
            return "Unable to present sign-in UI."
        }
    }
}

@MainActor
final class AuthManager {
    static let shared = AuthManager()

    private let linkedEmailKey = "linkedEmail"
    private let linkedProviderKey = "linkedProvider"
    private let linkedFlagKey = "hasLinkedEmail"

    private init() {}

    func registerLocal(email: String, password: String) throws {
        guard email.contains("@") else { throw AuthError.invalidEmail }
        guard password.count >= 6 else { throw AuthError.weakPassword }

        try KeychainService.save("localPassword", value: password)
        setLinked(email: email, provider: "local")
    }

    @MainActor
    func linkWithGoogle() async throws -> String {
        guard GIDSignIn.sharedInstance.configuration?.clientID != nil else {
            throw AuthError.missingClientID
        }
        guard let rootVC = Self.rootViewController() else {
            throw AuthError.noRootViewController
        }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        guard let email = result.user.profile?.email else {
            throw AuthError.missingEmail
        }

        setLinked(email: email, provider: "google")
        return email
    }

    func hasLinkedEmail() -> Bool {
        UserDefaults.standard.bool(forKey: linkedFlagKey)
    }

    func clearAuth() {
        UserDefaults.standard.set(false, forKey: linkedFlagKey)
        UserDefaults.standard.removeObject(forKey: linkedEmailKey)
        UserDefaults.standard.removeObject(forKey: linkedProviderKey)
        KeychainService.delete("localPassword")
    }

    private func setLinked(email: String, provider: String) {
        UserDefaults.standard.set(true, forKey: linkedFlagKey)
        UserDefaults.standard.set(email, forKey: linkedEmailKey)
        UserDefaults.standard.set(provider, forKey: linkedProviderKey)
    }

    @MainActor
    private static func rootViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first { $0 is UIWindowScene } as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
}
