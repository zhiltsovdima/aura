//
//  NewFaceDetector.swift
//  aura
//
//  Created by Dima Zhiltsov on 28.08.2023.
//

import UIKit

class Face: NSObject, NSCopying {
    var leftEye: CGPoint = .zero
    var rightEye: CGPoint = .zero
    var feature: CIFaceFeature?
    var bounds: CGRect = .zero
    var ci: CIImage?
    
    func copy(with zone: NSZone? = nil) -> Any {
        let newFace = Face()
        newFace.leftEye = leftEye
        newFace.rightEye = rightEye
        newFace.feature = feature
        newFace.bounds = bounds
        newFace.ci = ci
        return newFace
    }
}

class FaceDetector {
    private var _date: Date?
    private var _szImg: CGSize = .zero
    
    var cropFaces: Bool = false
    var highAccuracy: Bool = false
    var _faces: [Face] = []
    private var detectedFaceLayers: [CAShapeLayer] = []
    
    private func copyFaces() -> [Face] {
        return _faces.map { $0.copy() as! Face }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let det = FaceDetector()
        det.cropFaces = cropFaces
        det.highAccuracy = highAccuracy
        det._faces = copyFaces()
        det._szImg = _szImg
        return det
    }
    
    static func detectFaces(_ img: CIImage, qualityHigh: Bool) -> FaceDetector {
        let det = FaceDetector()
        det.highAccuracy = qualityHigh
        det.detectFaces(img)
        return det
    }
    
    func detectFaces(_ img: CIImage) {
        _date = Date()
        _faces = []
        
        guard let detector = getCIDetector() else { return }
        
        let options: [String: Any] = [CIDetectorAccuracy: highAccuracy ? CIDetectorAccuracyHigh : CIDetectorAccuracyLow]
        guard let features = detector.features(in: img, options: options) as? [CIFaceFeature] else { return }
        
        _szImg = img.extent.size
        
        for f in features {
            if f.hasLeftEyePosition && f.hasRightEyePosition {
                let face = Face()
                face.feature = f
                face.leftEye = pointShift(f.leftEyePosition, by: img.extent.origin)
                face.rightEye = pointShift(f.rightEyePosition, by: img.extent.origin)
                face.bounds = CGRect(x: f.bounds.origin.x - img.extent.origin.x,
                                     y: f.bounds.origin.y - img.extent.origin.y,
                                     width: f.bounds.size.width,
                                     height: f.bounds.size.height)
                if cropFaces {
                    let clImg = img.cropped(to: f.bounds)
                    let ciImg = clImg.transformed(by: CGAffineTransform(translationX: -f.bounds.origin.x, y: -f.bounds.origin.y))
                    face.ci = ciImg
                }
                _faces.append(face)
            }
        }
    }
        
    
    
    // Остальные методы остаются неизменными
    
    func getCIDetector() -> CIDetector? {
        struct Static {
            static var detectorsPool: [CIDetector] = []
        }
        
        let detectorsCount: Float = 3
        
        DispatchQueue.once(token: "detectorsPool") {
            while Static.detectorsPool.count < Int(detectorsCount) {
                if let detector = CIDetector(
                    ofType: CIDetectorTypeFace,
                    context: CIContext(options: nil),
                    options: [CIDetectorAccuracy: CIDetectorAccuracyLow]
                ) {
                    Static.detectorsPool.append(detector)
                }
            }
        }
        
        if Static.detectorsPool.isEmpty {
            return nil
        } else {
            let detector = Static.detectorsPool.removeFirst()
            return detector
        }
    }
    
    
    
    func pointShift(_ point: CGPoint, by origin: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - origin.x, y: point.y - origin.y)
    }

    func pointScale(_ point: CGPoint, scale: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scale, y: point.y * scale)
    }

    func frameScale(_ frame: CGRect, scale: CGFloat) -> CGRect {
        return CGRect(x: frame.origin.x * scale, y: frame.origin.y * scale, width: frame.size.width * scale, height: frame.size.height * scale)
    }

}
    extension DispatchQueue {
        private static var _onceTracker = [String]()
        
        class func once(token: String, block: () -> Void) {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            
            if _onceTracker.contains(token) {
                return
            }
            
            _onceTracker.append(token)
            block()
        }
    }
