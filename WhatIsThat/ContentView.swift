//
//  ContentView.swift
//  WhatIsThat
//
//  Created by Cem Akkaya on 24/03/26.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var visionManager = VisionManager()
    
    var body: some View {
        ZStack {
            
            CameraView(session: visionManager.captureSession)
            VStack {
                
                Spacer()
                
                VStack(spacing: 15) {
                    Text(visionManager.detectedObject)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding()
            }
        }
        .onAppear {
            visionManager.setupCamera()
            
            DispatchQueue.global(qos: .userInitiated).async {
                visionManager.captureSession.startRunning()
            }
        }
    }
}

#Preview {
    ContentView()
}
