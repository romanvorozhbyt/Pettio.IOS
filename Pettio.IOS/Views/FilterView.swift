//
//  FilterView.swift
//  Pettio.IOS
//
//  Created by Katerina Kaverina on 06.02.2026.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: FeedViewModel
    @State private var selectedBreeds: Set<String> = []
    
    let allBreeds = ["Golden Retriever", "Labrador", "German Shepherd", "Bulldog", "Poodle", 
                     "Beagle", "Siamese", "Persian", "Maine Coon", "British Shorthair"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Age Range") {
                    HStack {
                        Text("Min: \(viewModel.minAge)")
                        Slider(value: .init(get: { Double(viewModel.minAge) }, 
                                           set: { viewModel.minAge = Int($0) }), 
                              in: 0...15, step: 1)
                    }
                    
                    HStack {
                        Text("Max: \(viewModel.maxAge)")
                        Slider(value: .init(get: { Double(viewModel.maxAge) }, 
                                           set: { viewModel.maxAge = Int($0) }), 
                              in: 0...15, step: 1)
                    }
                }
                
                Section("Size") {
                    Picker("Pet Size", selection: $viewModel.selectedSize) {
                        Text("All Sizes").tag(Optional<PetSize>(nil))
                        ForEach(PetSize.allCases, id: \.self) { size in
                            Text(size.rawValue).tag(Optional(size))
                        }
                    }
                }
                
                Section("Purpose") {
                    Picker("Looking For", selection: $viewModel.selectedPurpose) {
                        Text("All Purposes").tag(Optional<PetPurpose>(nil))
                        ForEach(PetPurpose.allCases, id: \.self) { purpose in
                            Text(purpose.rawValue).tag(Optional(purpose))
                        }
                    }
                }
                
                Section("Breeds") {
                    ForEach(allBreeds, id: \.self) { breed in
                        Toggle(breed, isOn: .init(
                            get: { selectedBreeds.contains(breed) },
                            set: { isOn in
                                if isOn {
                                    selectedBreeds.insert(breed)
                                } else {
                                    selectedBreeds.remove(breed)
                                }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Filter Pets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        viewModel.filteredBreeds = Array(selectedBreeds)
                        viewModel.applyFilters()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = FeedViewModel()
    FilterView(viewModel: viewModel)
}
