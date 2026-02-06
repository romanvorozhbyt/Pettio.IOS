//
//  FeedView.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import SwiftUI
import SwiftData

struct FeedView: View {
    @State private var viewModel = FeedViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var allPets: [Pet]
    @State private var showFilter = false
    @State private var myPetId: String = "current-user-pet" // This would come from user context
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Discover")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { showFilter = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.headline)
                    }
                }
                .padding(.horizontal)
                
                // Card stack
                ZStack(alignment: .center) {
                    if viewModel.remainingCards > 0 {
                        // Show remaining cards in background (stacked effect)
                        if viewModel.currentIndex + 1 < viewModel.petCards.count {
                            SwipeCardView(
                                pet: viewModel.petCards[viewModel.currentIndex + 1],
                                onSwipeLeft: {},
                                onSwipeRight: {},
                                onSuperLike: {}
                            )
                            .offset(y: 8)
                            .opacity(0.9)
                            .scaleEffect(0.95)
                        }
                        
                        // Current card
                        if let pet = viewModel.currentPet {
                            SwipeCardView(
                                pet: pet,
                                onSwipeLeft: {
                                    viewModel.swipeLeft(myPetId: myPetId, modelContext: modelContext)
                                },
                                onSwipeRight: {
                                    viewModel.swipeRight(myPetId: myPetId, modelContext: modelContext)
                                },
                                onSuperLike: {
                                    viewModel.superLike(myPetId: myPetId, modelContext: modelContext)
                                }
                            )
                        }
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.pink)
                            
                            Text("No more pets to discover")
                                .font(.headline)
                            
                            Text("Come back later for more matches!")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Button(action: { viewModel.reset() }) {
                                Text("Refresh Feed")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.pink)
                                    .cornerRadius(12)
                            }
                            .padding()
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
                .frame(height: 500)
                
                // Action buttons
                if viewModel.remainingCards > 0 {
                    HStack(spacing: 16) {
                        // Dislike button
                        Button(action: {
                            viewModel.swipeLeft(myPetId: myPetId, modelContext: modelContext)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // Super like button
                        Button(action: {
                            viewModel.superLike(myPetId: myPetId, modelContext: modelContext)
                        }) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.yellow)
                        }
                        
                        Spacer()
                        
                        // Like button
                        Button(action: {
                            viewModel.swipeRight(myPetId: myPetId, modelContext: modelContext)
                        }) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.pink)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical)
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showFilter) {
            FilterView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.petCards = allPets.shuffled()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pet.self, configurations: config)
    
    return FeedView()
        .modelContainer(container)
}
