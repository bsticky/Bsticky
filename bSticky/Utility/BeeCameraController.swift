//
//  BeeCameraController.swift
//  bSticky
//
//  Created by mima on 2021/01/26.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit
import AVFoundation

protocol BeeCameraControllerDelegate: class {
    func photoSaveButtonTapped(filePath: String!)
    func displayCameraPermissionAlert()
}

class BeeCameraController: UIViewController, AVCapturePhotoCaptureDelegate, BeePhotoPrevewDelegate, BeeCameraViewDelegate {
    
    weak var delegate: BeeCameraControllerDelegate?
    var jpegcompressionQuality: CGFloat = 0.5

    var captureSession: AVCaptureSession!
    
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.off
    var currentCameraPosition: CameraPosition?
    
    weak var cameraView: BeeCameraView!
    
    // MARK: - View lifecycle
    
    //var orientation = UIApplication.shared.statusBarOrientation   // version < 13.0
    var orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // preview orientation
        if let connection =  self.previewLayer?.connection  {
            //orientation = UIApplication.shared.statusBarOrientation   // version < 13.0
            guard let orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation else { return }
            
            self.orientation = orientation

            switch orientation {
            case .portrait:           updatePreviewOrientation(for: connection, to: .portrait)
            case .landscapeRight:     updatePreviewOrientation(for: connection, to: .landscapeRight)
            case .landscapeLeft:      updatePreviewOrientation(for: connection, to: .landscapeLeft)
            case .portraitUpsideDown: updatePreviewOrientation(for: connection, to: .portraitUpsideDown)
            default:                  updatePreviewOrientation(for: connection, to: .portrait)
            }
        }
    }
    
    private func updatePreviewOrientation(for connection: AVCaptureConnection, to orientation: AVCaptureVideoOrientation) {
           if connection.isVideoOrientationSupported {
               connection.videoOrientation = orientation
           }
        self.previewLayer?.frame = self.view.bounds
    }
    

    // MARK: - Prepare
    
    func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCaptureSession()}}
                else {
                    self.handleDismiss()}
            }
        case .denied:
            delegate?.displayCameraPermissionAlert()
            self.handleDismiss()
        case .restricted:
            displayAlert(title: "Camera permission restricted",
                         message: "To use the image sticky please authorize the camera permission",
                         actionTitle: "Ok")
            // self.handleDismiss()
        default:
            print("something has wrong due to we can't access the camera.")
            displayAlert(title: "Camera permission error",
                         message: "something has wrong due to we can't access the camera.",
                         actionTitle: "Ok")
            // self.handleDismiss()
        }
    }

    private func setupCaptureSession() {
        // create capture session
        self.captureSession = AVCaptureSession()
        
        DispatchQueue.main.async {
            do {
                try self.configureCaptureDevice()
                try self.configureDeviceInputs()
                try self.configurePhotoOutput()
                self.setupUI()
            } catch let error {
                self.displayAlert(title: "something has wrong due to we can't open the camera",
                             message: error.localizedDescription,
                             actionTitle: "Ok")
                // self.handleDismiss()
            }
        }
    }

    // MARK: - Configure session
    
    private func configureCaptureDevice() throws {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        let cameras = session.devices.compactMap { $0 }
        if cameras.isEmpty { throw CameraControllerError.noCamerasAvailable}
        
        for camera in cameras {
            if camera.position == .front { self.frontCamera = camera }
            if camera.position == .back { self.rearCamera = camera }
        }
    }
    
    private func configureDeviceInputs() throws {
        if let rearCamera = self.rearCamera {
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession?.addInput(self.rearCameraInput!)
            }
            
            self.currentCameraPosition = .rear
        }
        else if let frontCamera = self.frontCamera {
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                
                self.currentCameraPosition = .front
            }
        }
    }
    
    private func configurePhotoOutput() throws {
        self.photoOutput = AVCapturePhotoOutput()
        self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(self.photoOutput!) {
            captureSession.addOutput(self.photoOutput!)
        }
        
        // set preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
       
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspect
        
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
      
        captureSession.startRunning()
    }

    // MARK: - setup UI
    
    private func setupUI() {
        let cameraView = BeeCameraView()
        view.addSubview(cameraView)
        
        self.cameraView = cameraView
        self.cameraView.delegate = self
        
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cameraView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            cameraView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func setPreview(capturedImage: UIImage) {
        // this view will be dismissed by touch save or cancel button
        let photoPreview = BeePhotoPreview()
       
        photoPreview.delegate = self
        photoPreview.photoImageView.image = capturedImage
        
        self.view.addSubview(photoPreview)
        
        NSLayoutConstraint.activate([
            photoPreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoPreview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoPreview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            photoPreview.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    // MARK: - Capture image
    
    func shutterButtonTapped() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        /*
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
        }
        */
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        var previewImage: UIImage = UIImage(data: imageData)!
        
        if currentCameraPosition == .front {
            previewImage = UIImage(cgImage: previewImage.cgImage!, scale: previewImage.scale, orientation: .leftMirrored)
        }
        
        switch self.orientation {
        case .portrait:
            previewImage = UIImage(cgImage: previewImage.cgImage!, scale: previewImage.scale, orientation: .right)
        case .landscapeRight:
            previewImage = UIImage(cgImage: previewImage.cgImage!, scale: previewImage.scale, orientation: .up)
        case .landscapeLeft:
            previewImage = UIImage(cgImage: previewImage.cgImage!, scale: previewImage.scale, orientation: .down)
        case .portraitUpsideDown:
            previewImage = UIImage(cgImage: previewImage.cgImage!, scale: previewImage.scale, orientation: .left)
        default:
            displayAlert(title: "Orientation Error",
                         message: "Can't find device's current orientation",
                         actionTitle: "Ok")
            // fatalError("Unexpected orientation")
        }
        
        setPreview(capturedImage: previewImage)
    }
    
    // MARK: - Save image
    
    func stickButtonTapped(image: UIImage!) {
        
        func saveImage() throws -> String? {
                    // image
            guard let imageToSave = image else { throw CameraControllerError.unknown }
            
            let url = try BeeMediaHelper.generateNewFileURL(mediaType: BeeMediaHelper.MediaType.image)
            
            // TODO: Image quality by user setting ( user defalut value)
            if let data = imageToSave.jpegData(compressionQuality: jpegcompressionQuality) {
                try data.write(to: url)
            }
            return url.lastPathComponent
        }

        do {
            let filePath = try saveImage()
            self.delegate?.photoSaveButtonTapped(filePath: filePath)
        } catch let error {
            displayAlert(title: "Save Image Error",
                         message: error.localizedDescription,
                         actionTitle: "ok")
            //self.delegate?.stickPhoto(filePath: nil)
        }
        handleDismiss()
    }
    
    // MARK: - Camera toggle action
    
    func flashButtonTapped() {
        if flashMode == .on {
            flashMode = .off
            cameraView.flashButton.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
        } else {
            flashMode = .on
            cameraView.flashButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        }
    }
    
    func switchCameraButtonTapped() {
        if currentCameraPosition == .front {
            // switch to rear
            guard let frontCameraInput = self.frontCameraInput, captureSession.inputs.contains(frontCameraInput),
                  let rearCamera = self.rearCamera else {
                return
            }
            self.rearCameraInput = try? AVCaptureDeviceInput(device: rearCamera)
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession.addInput(self.rearCameraInput!)
                
                self.currentCameraPosition = .rear
            }
        } else if currentCameraPosition == .rear {
            // switch to front
            guard let rearCameraInput = self.rearCameraInput, captureSession.inputs.contains(rearCameraInput),
                  let frontCamera = self.frontCamera else {
                return
            }
            self.frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera)
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                
                self.currentCameraPosition = .front
            }
        }
    }

    // MARK: - Dismiss
    
    func cancelButtonTapped() {
        self.handleDismiss()
    }
    
    private func handleDismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Alert controller
    
    func displayAlert(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionTitle,
                                     style: .default,
                                     handler: {(alert: UIAlertAction!)
                                        in self.handleDismiss()})
        
        alertController.addAction(okAction)
        
        showDetailViewController(alertController, sender: nil)
    }
}

extension BeeCameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}
