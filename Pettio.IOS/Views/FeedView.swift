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
                            .id(pet.id)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 12)
            }
        }
        .sheet(isPresented: $showFilter) {
            FilterView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.loadPets(from: modelContext)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pet.self, configurations: config)
    
    return FeedView()
        .modelContainer(container)
}
