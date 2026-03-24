//
//  VisionManager.swift
//  WhatIsThat
//
//  Created by Cem Akkaya on 24/03/26.
//

import SwiftUI
import CoreML
import Vision

@Observable
class VisionManager {
    var detectedObject: String?
    var isAnalyzing = false
    
    func analyseObject(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            print("Error: Could not convert UIImage to CIImage.")
            return
        }
        
        isAnalyzing = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model) else {
                print("Error: Model could not be loaded.")
                DispatchQueue.main.async { self.isAnalyzing = false }
                return
            }
            
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNClassificationObservation],
                      let topResult = results.first else {
                    DispatchQueue.main.async { self.isAnalyzing = false }
                    return
                }
                
                // Take only the first label (before any comma)
                let identifier = topResult.identifier
                    .components(separatedBy: ",").first?
                    .trimmingCharacters(in: .whitespaces) ?? topResult.identifier
                DispatchQueue.main.async {
                    self.detectedObject = identifier
                    self.isAnalyzing = false
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try? handler.perform([request])
        }
    }
}
