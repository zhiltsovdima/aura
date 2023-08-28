//
//  FaceDetector.swift
//  aura
//
//  Created by Dima Zhiltsov on 28.08.2023.
//

import UIKit

import Vision

//class Face {
//    var leftEye: CGPoint = .zero
//    var rightEye: CGPoint = .zero
//    var feature: CGPoint = .zero
//    var bounds: CGRect = .zero
//}
//
//class FaceDetector {
//    private var detectedFaces: [Face] = []
//
//    var faces: [Face] {
//        return detectedFaces
//    }
//
//    func detectFaces(_ image: CIImage) {
//        let request = VNDetectFaceLandmarksRequest { request, error in
//            if let error = error {
//                print("Face detection error: \(error)")
//                return
//            }
//            
//            guard let results = request.results as? [VNFaceObservation] else {
//                return
//            }
//            
//            self.detectedFaces = results.map { faceObservation in
//                let face = Face()
//                // Здесь вы можете заполнить свойства объекта Face на основе данных faceObservation
//                return face
//            }
//        }
//
//        let faceDetectionHandler = VNImageRequestHandler(ciImage: image, orientation: .right, options: [:])
//        do {
//            try faceDetectionHandler.perform([request])
//        } catch {
//            print("Face detection error: \(error)")
//        }
//    }
    
//    func fillFaces(to size: CGSize, invertY: Bool) {
//        let scale = size.width / _szImg.width
//        
//        for face in detectedFaces {
//            var transformedFace = face
//            
//            if invertY {
//                transformedFace.bounds.origin.y = size.height - transformedFace.bounds.origin.y - transformedFace.bounds.size.height
//            }
//            
//            transformedFace.bounds.origin.x *= scale
//            transformedFace.bounds.origin.y *= scale
//            transformedFace.bounds.size.width *= scale
//            transformedFace.bounds.size.height *= scale
//            
//            // Обновите другие свойства, если это необходимо
//            // Например: transformedFace.leftEye.x *= scale
//            // и так далее...
//            
//            face.bounds = transformedFace.bounds
//            // ... обновите остальные свойства
//        }
//    }

//}
