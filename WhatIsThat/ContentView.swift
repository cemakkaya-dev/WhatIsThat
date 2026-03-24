//
//  ContentView.swift
//  WhatIsThat
//
//  Created by Cem Akkaya on 24/03/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var capturedImage: UIImage?
    @State private var showCamera = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                } else {
                    ContentUnavailableView(
                        "No Photo",
                        systemImage: "photo",
                        description: Text("Tap the camera button to take a photo.")
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("WhatIsThat")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCamera = true
                    } label: {
                        Image(systemName: "camera.fill")
                    }
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(capturedImage: $capturedImage)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ContentView()
}
