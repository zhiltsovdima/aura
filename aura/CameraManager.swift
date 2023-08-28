//
//  CameraManager.swift
//  aura
//
//  Created by Dima Zhiltsov on 27.08.2023.
//


import AVFoundation
import UIKit
import Vision

protocol CameraManagerDelegate: AnyObject {
    func detectFaces(in image: CIImage)
}

class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
            
    private var currentCamera: AVCaptureDevice.Position = .front // Изначально установите фронтальную камеру
    
    private var lastFrame: CIImage?
    var videoOutput: AVCaptureVideoDataOutput!


    var isFrontCamera: Bool {
            return currentCamera == .front
        }
    
    init(with delegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        super.init()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera)
        else {
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
    }
    
    func setVideoLayer(_ layer: CALayer) {
        videoPreviewLayer?.frame = layer.bounds
        layer.addSublayer(videoPreviewLayer!)
    }
    
    func start() {
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stop() {
        captureSession.stopRunning()
    }

    
    func checkCameraAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        default:
            completion(false)
        }
    }
    
    func toggleCamera() {
            captureSession.beginConfiguration()
            
            // Удаляем текущий вход (камеру)
            if let currentInput = captureSession.inputs.first {
                captureSession.removeInput(currentInput)
            }
            
            // Переключаемся между фронтальной и задней камерой
            currentCamera = (currentCamera == .front) ? .back : .front
            
            // Создаем новый AVCaptureDeviceInput на основе выбранной камеры
            if let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCamera),
               let newInput = try? AVCaptureDeviceInput(device: camera) {
                if captureSession.canAddInput(newInput) {
                    captureSession.addInput(newInput)
                }
            }
            
            // Применяем изменения
            captureSession.commitConfiguration()
        }

}
