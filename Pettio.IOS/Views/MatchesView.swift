//
//  MatchesView.swift
//  Pettio.IOS
//
//  Created by Roman Vorozhbyt on 06.02.2026.
//

import SwiftUI
import SwiftData

struct MatchesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var matches: [Match]
    
    var sortedMatches: [Match] {
        matches.sorted { ($0.lastMessageAt ?? $0.createdAt) > ($1.lastMessageAt ?? $1.createdAt) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if matches.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Matches Yet")
                            .font(.headline)
                        
                        Text("Start swiping to find matches!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(sortedMatches) { match in
                            NavigationLink(destination: MatchDetailView(match: match)) {
                                MatchRow(match: match)
                            }
                        }
                        .onDelete(perform: deleteMatch)
                    }
                    .listStyle(.inset)
                }
            }
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func deleteMatch(at offsets: IndexSet) {
        for index in offsets {
            let match = sortedMatches[index]
            modelContext.delete(match)
        }
    }
}

struct MatchRow: View {
    let match: Match
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // Pet avatar placeholder
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                    
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.gray)
                }
                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(match.matchedPet?.name ?? "Unknown Pet")
                        .font(.headline)
                    
                    HStack(spacing: 8) {
                        Label(
                            match.matchedPet?.breed ?? "Unknown",
                            systemImage: "pawprint.fill"
                        )
                        .font(.caption)
                        .foregroundColor(.gray)
                        
                        Image(systemName: match.matchType == .like ? "heart.fill" : "star.fill")
                            .font(.caption)
                            .foregroundColor(match.matchType == .like ? .pink : .yellow)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Matched")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Text(match.createdAt, style: .relative)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct MatchDetailView: View {
    @Environment(\.dismiss) var dismiss
    let match: Match
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                Spacer()
            }
            .padding()
            
            if let pet = match.matchedPet {
                VStack(alignment: .leading, spacing: 12) {
                    // Pet info header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(pet.name), \(pet.age)")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack(spacing: 8) {
                                Label(pet.breed, systemImage: "pawprint.fill")
                                    .font(.caption)
                                Label(pet.location, systemImage: "location.fill")
                                    .font(.caption)
                            }
                            .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Label(pet.purpose.rawValue, systemImage: "heart.fill")
                                .font(.caption)
                                .padding(8)
                                .background(Color.pink.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    Divider()
                    
                    // Bio
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                        Text(pet.bio)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                    // Interests
                    if !pet.interests.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Interests")
                                .font(.headline)
                            
                            Wrap(items: pet.interests) { interest in
                                Text(interest)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    
                    // Match info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Match Information")
                            .font(.headline)
                        
                        HStack {
                            Label("Matched", systemImage: match.matchType == .like ? "heart.fill" : "star.fill")
                            Spacer()
                            Text(match.createdAt, style: .date)
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Message button
            Button(action: {}) {
                Text("Send Message")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(12)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Wrap<T: Hashable, V: View>: View {
    let items: [T]
    let content: (T) -> V
    
    private let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 8)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}

#Preview {
    MatchesView()
}
