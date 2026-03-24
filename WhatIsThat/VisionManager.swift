//
//  VisionManager.swift
//  WhatIsThat
//
//  Created by Cem Akkaya on 24/03/26.
//

import SwiftUI
import CoreML
import Vision
import AVFoundation

@Observable
class VisionManager: NSObject {
    var detectedObject: String = "Point the camera at an object..."
    let captureSession = AVCaptureSession()
    
    func analyseObject(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model) else {
            print("Error: Model could not be loaded.")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                return
            }
            
            let identifier = topResult.identifier
            DispatchQueue.main.async {
                self.detectedObject = identifier
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        try? handler.perform([request])
    }
    
    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
    }
}

extension VisionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        analyseObject(image: ciImage)
    }
}
