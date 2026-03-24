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
    @State private var visionManager = VisionManager()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if let capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                } else {
                    ContentUnavailableView(
                        "No Photo",
                        systemImage: "photo",
                        description: Text("Tap the camera button to take a photo.")
                    )
                }
                
                if visionManager.isAnalyzing {
                    ProgressView("Analyzing...")
                        .padding()
                        .glassEffect(in: .rect(cornerRadius: 20))
                }
                
                if let result = visionManager.detectedObject, !visionManager.isAnalyzing {
                    Text(result.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .glassEffect(in: .rect(cornerRadius: 20))
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("WhatIsThat?")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
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
            .onChange(of: capturedImage) { _, newImage in
                if let newImage {
                    withAnimation {
                        visionManager.detectedObject = nil
                    }
                    visionManager.analyseObject(image: newImage)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
