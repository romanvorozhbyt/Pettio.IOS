//
//  SwipeCardView.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import SwiftUI

struct SwipeCardView: View {
    let pet: Pet
    var onSwipeLeft: () -> Void = {}
    var onSwipeRight: () -> Void = {}
    var onSuperLike: () -> Void = {}
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var currentImageIndex: Int = 0
    @State private var scale: CGFloat = 1.0
    
    private var placeholderImage: some View {
        ZStack {
            Color.gray.opacity(0.3)
            Image(systemName: "photo.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background image - prioritize local images
                if let localImageName = pet.imageName {
                    // Local image from assets
                    Image(localImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else if !pet.imageURLs.isEmpty {
                    let imagePath = pet.imageURLs[currentImageIndex]
                    
                    if imagePath.hasPrefix("http://") || imagePath.hasPrefix("https://") {
                        AsyncImage(url: URL(string: imagePath)) { phase in
                            switch phase {
                            case .empty:
                                placeholderImage
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .clipped()
                            case .failure:
                                placeholderImage
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                            @unknown default:
                                placeholderImage
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                            }
                        }
                    } else {
                        // Local image from imageURLs array
                        Image(imagePath)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                } else {
                    placeholderImage
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            
            // Pet info overlay
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(pet.name), \(pet.age)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            Label(pet.breed, systemImage: "pawprint.fill")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Label(pet.size.rawValue, systemImage: "ruler")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        ForEach(pet.interests.prefix(2), id: \.self) { interest in
                            Text(interest)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Text(pet.bio)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    Label(pet.location, systemImage: "location.fill")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Label(pet.purpose.rawValue, systemImage: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .cornerRadius(16)
        .shadow(radius: 8)
        .offset(offset)
        .rotationEffect(.degrees(rotation), anchor: .center)
        .scaleEffect(scale)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    withAnimation(.easeOut(duration: 0.1)) {
                        offset = gesture.translation
                        rotation = Double(gesture.translation.width / 40)
                        scale = 1.0
                    }
                }
                .onEnded { gesture in
                    let threshold: CGFloat = 100
                    
                    if gesture.translation.width > threshold {
                        // Swipe right
                        withAnimation(.easeOut(duration: 0.3)) {
                            offset = CGSize(width: 500, height: 0)
                            rotation = 20
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onSwipeRight()
                        }
                    } else if gesture.translation.width < -threshold {
                        // Swipe left
                        withAnimation(.easeOut(duration: 0.3)) {
                            offset = CGSize(width: -500, height: 0)
                            rotation = -20
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onSwipeLeft()
                        }
                    } else if gesture.translation.height < -threshold {
                        // Super like (swipe up)
                        withAnimation(.easeOut(duration: 0.3)) {
                            offset = CGSize(width: 0, height: -500)
                            scale = 1.2
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onSuperLike()
                        }
                    } else {
                        // Return to center
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            offset = .zero
                            rotation = 0
                            scale = 1.0
                        }
                    }
                }
        )
        }
    }
}

#Preview {
    SwipeCardView(
        pet: Pet(
            name: "Max",
            breed: "Golden Retriever",
            age: 3,
            size: .large,
            type: .dog,
            location: "San Francisco, CA",
            bio: "Friendly and energetic! Love playing fetch!",
            imageURLs: [],
            interests: ["playmate", "friendship"],
            purpose: .playmate
        )
    )
    .frame(height: 500)
}
