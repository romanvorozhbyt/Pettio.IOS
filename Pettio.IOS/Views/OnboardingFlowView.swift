//
//  OnboardingFlowView.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 10.02.2026.
//

import SwiftUI

struct OnboardingFlowView: View {
    @Binding var hasSeenWelcome: Bool
    @Binding var hasLinkedEmail: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var authError: String? = nil

    var body: some View {
        if !hasSeenWelcome {
            WelcomeView {
                hasSeenWelcome = true
            }
        } else if !hasLinkedEmail {
            AuthLinkView(
                email: $email,
                password: $password,
                authError: $authError,
                onGoogle: handleGoogleSignIn,
                onEmail: handleLocalSignup
            )
        } else {
            CreatePetView()
        }
    }

    private func handleGoogleSignIn() {
        Task {
            do {
                _ = try await AuthManager.shared.linkWithGoogle()
                hasLinkedEmail = true
            } catch {
                authError = error.localizedDescription
            }
        }
    }

    private func handleLocalSignup() {
        do {
            try AuthManager.shared.registerLocal(email: email, password: password)
            hasLinkedEmail = true
        } catch {
            authError = error.localizedDescription
        }
    }
}

struct WelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "heart.fill")
                .font(.system(size: 64))
                .foregroundColor(.pink)

            Text("Welcome to Pettio")
                .font(.title)
                .fontWeight(.bold)

            Text("Find the perfect playmate for your pet.")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            Button(action: onContinue) {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}

struct AuthLinkView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var authError: String?
    let onGoogle: () -> Void
    let onEmail: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Text("Link your email")
                .font(.title2)
                .fontWeight(.bold)

            Text("Sign in to keep your account safe and synced.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 12) {
                Button(action: onGoogle) {
                    HStack(spacing: 8) {
                        Image(systemName: "g.circle.fill")
                        Text("Continue with Google")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
                }

                VStack(spacing: 10) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password (min 6 chars)", text: $password)
                        .textFieldStyle(.roundedBorder)

                    Button(action: onEmail) {
                        Text("Continue with Email")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(12)
                    }
                }

                if let authError {
                    Text(authError)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    OnboardingFlowView(hasSeenWelcome: .constant(false), hasLinkedEmail: .constant(false))
}
