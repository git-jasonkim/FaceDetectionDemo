//
//  ViewController.swift
//  FaceDetection
//
//  Created by Jason Kim on 7/13/18.
//  Copyright © 2018 jkLabs. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class CameraController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let captureSession = AVCaptureSession()
    let captureDevice = AVCaptureDevice.default(for: .video)
    let photoOutput = AVCapturePhotoOutput()
    let dataOutput = AVCaptureVideoDataOutput()

    private var scannedFaceViews = [UIImageView]()
    
    fileprivate func setupCaptureSession() {
        guard let captureDevice = captureDevice else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print(err.localizedDescription)
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.canAddOutput(photoOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    var selectedFace: Face?
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            if let err = err {
                print("Failed to detech faces: " , err)
                return
            }
            
            DispatchQueue.main.async {
                _ = self.scannedFaceViews.map {$0.removeFromSuperview()}
                self.scannedFaceViews.removeAll()
                guard let selectedFace = self.selectedFace else { return }
                if let faces = req.results as? [VNFaceObservation] {
                    for face in faces {
                        
                        guard let frame = self.faceFrame(from: face.boundingBox, faceCoverage: selectedFace.faceCoverage) else { return }
                        let faceView = UIImageView(frame: frame)
                        faceView.image = UIImage(named: selectedFace.image)
                        faceView.contentMode = .scaleAspectFill
                        faceView.alpha = 1.0
                        self.previewView.addSubview(faceView)
                        self.scannedFaceViews.append(faceView)
                    }
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: self.imageOrientation, options: [:])
        do {
            try handler.perform([request])
        } catch let reqErr {
            print("Failed to perform request:", reqErr)
        }
    }

    let previewView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var facesCollectionView: FacesCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = FacesCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.cameraController = self
        return cv
    }()
    
    fileprivate func faceFrame(from boundingBox: CGRect, faceCoverage: CGFloat) -> CGRect? {
        
        //translate camera frame to frame inside the ARSKView
        let width = boundingBox.width * self.view.bounds.width * faceCoverage
        let height = boundingBox.height * self.view.bounds.height * faceCoverage
        let x = boundingBox.origin.x * self.view.bounds.width - (width - self.view.frame.width * boundingBox.width) / 2
        let y = (1 - boundingBox.origin.y) * self.view.bounds.height - height
        let origin = CGPoint(x: x, y: y)
        let size = CGSize(width: width, height: height)
        
        return CGRect(origin: origin, size: size)
    }
    
    fileprivate func setupViews() {
        view.addSubview(previewView)
        previewView.anchor(centerX: nil, centerY: nil, top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, leading: nil, trailing: nil, paddingLeading: 0, paddingTrailing: 0)
        view.addSubview(facesCollectionView)
        facesCollectionView.anchor(centerX: nil, centerY: nil, top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: view.frame.height * 0.1, paddingRight: 0, width: 0, height: 50, leading: nil, trailing: nil, paddingLeading: 0, paddingTrailing: 0)
    }
    
    private var imageOrientation: CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portrait: return .right
        case .landscapeRight: return .down
        case .portraitUpsideDown: return .left
        case .unknown: fallthrough
        case .faceUp: fallthrough
        case .faceDown: fallthrough
        case .landscapeLeft: return .up
        }
    }
    
}

