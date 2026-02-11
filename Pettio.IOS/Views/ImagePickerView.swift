//
//  ImagePickerView.swift
//  Pettio.IOS
//
//  Created by Катерина Каверина on 10.02.2026.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @Binding var imageData: Data?
    let label: String
    
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 12) {
            // Image preview
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 120, height: 120)
            
            // Photo picker button
            PhotosPicker(selection: $selectedItem, matching: .images, label: {
                Text(label)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            })
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let newValue {
                        if let data = try await newValue.loadTransferable(type: Data.self) {
                            imageData = data
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ImagePickerView(imageData: .constant(nil), label: "Preview")
}
