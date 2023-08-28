//
//  ViewController.swift
//  aura
//
//  Created by Dima Zhiltsov on 27.08.2023.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession: AVCaptureSession!
    var videoOutput: AVCaptureVideoDataOutput!
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    let faceDetector = FaceDetector()
    private var detectedFaceLayers: [CAShapeLayer] = []

    
    private var cameraManager: CameraManager!
        
    @IBOutlet weak var cameraView: UIView!
    private var lastFrame: CIImage?
    
    var faceRectView: UIView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cameraManager = CameraManager(with: self)
        cameraManager.setVideoLayer(cameraView.layer)
        cameraManager.start()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 20) {
            self.cameraManager.stop()
        }
        
        faceRectView = UIView()
        faceRectView.layer.borderColor = UIColor.red.cgColor
        faceRectView.layer.borderWidth = 2.0
        view.addSubview(faceRectView)
    }
    
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
           let ciImage = CIImage(cvImageBuffer: imageBuffer)
            lastFrame = ciImage
            DispatchQueue.main.async {
                self.detectFace(on: ciImage)
            }
        }
    }
    
    func detectFace(on image: CIImage) {
        faceDetector.detectFaces(image)
        
        DispatchQueue.main.async {
               self.removeDetectedFaceLayers() // Очищаем предыдущие прямоугольники
               self.drawDetectedFaces() // Рисуем прямоугольники вокруг обнаруженных лиц
           }
//           let faceRequest = VNDetectFaceRectanglesRequest()
//           let faceRequestHandler = VNImageRequestHandler(ciImage: image, orientation: CGImagePropertyOrientation(rawValue: 6)!)
//
//           do {
//               try faceRequestHandler.perform([faceRequest])
//               if let results = faceRequest.results as? [VNFaceObservation], let firstResult = results.first {
//                   let faceBoundingBox = firstResult.boundingBox
//                   updateFaceRectView(position: faceBoundingBox)
//               } else {
//                   // Hide the rectangle if no face is detected
//                   faceRectView.isHidden = true
//               }
//           } catch {
//               print(error)
//           }
       }
    
    func removeDetectedFaceLayers() {
        for subview in view.subviews {
            if subview == faceRectView {
                subview.removeFromSuperview()
            }
        }
    }

    
    func drawDetectedFaces() {
        for face in faceDetector._faces {
            let boundingBox = face.bounds
            let transformedRect = videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)
            self.updateFaceRectView(frame: transformedRect)
        }
    }

    func updateFaceRectView(frame: CGRect) {
        DispatchQueue.main.async {
            self.faceRectView.frame = frame
        }
    }

    
//    func updateFaceRectView(position: CGRect) {
//        let screenSize = UIScreen.main.bounds.size
//        let transformedRect = CGRect(x: position.origin.x * screenSize.width,
//                                     y: (1 - position.origin.y - position.size.height) * screenSize.height,
//                                     width: position.size.width * screenSize.width,
//                                     height: position.size.height * screenSize.height)
//        
//        faceRectView.frame = transformedRect
//        faceRectView.isHidden = false
//    }

}
