//
//  CameraController.swift
//  splitty
//
//  Created by Pranjal Satija on 9/23/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import AVFoundation
import UIKit

protocol CameraControllerDelegate: class {
    func cameraController(_ cameraController: CameraController, didOutputMachineReadableCode code: String)
}

class CameraController: NSObject {
    weak var delegate: CameraControllerDelegate?

    private var camera = AVCaptureDevice.default(for: .video)
    private var cameraInput: AVCaptureDeviceInput!
    private var metadataOutput = AVCaptureMetadataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var scannedCodeStrings = Set<String>()
    private var session = AVCaptureSession()

    func configure() throws {
        guard let camera = camera else {
            throw Error.noCamerasAvailable
        }

        guard AVCaptureDevice.authorizationStatus(for: .video) != .denied else {
            throw Error.cameraAccessDenied
        }

        session.sessionPreset = .high

        cameraInput = try AVCaptureDeviceInput(device: camera)

        if session.canAddInput(cameraInput) && session.canAddOutput(metadataOutput) {
            session.addInput(cameraInput)
            session.addOutput(metadataOutput)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        } else {
            throw Error.unableToConfigureCaptureSession
        }

        session.startRunning()
    }

    func displayPreview(on view: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }

    func resetScannedCodes() {
        scannedCodeStrings = []
    }
}

extension CameraController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        guard let codes = metadataObjects as? [AVMetadataMachineReadableCodeObject] else {
            return
        }

        let codeStrings = codes.compactMap { $0.stringValue }.filter { !scannedCodeStrings.contains($0) }
        codeStrings.forEach { delegate?.cameraController(self, didOutputMachineReadableCode: $0) }
        scannedCodeStrings.formUnion(codeStrings)
    }
}

extension CameraController {
    enum Error: LocalizedError {
        case cameraAccessDenied
        case noCamerasAvailable
        case unableToConfigureCaptureSession

        var errorDescription: String? {
            switch self {
            case .cameraAccessDenied:
                return "Please go to Settings and enable camera access for Splitty to use this feature."
            case .noCamerasAvailable:
                return "It seems like your device doesn't have any cameras."
            case .unableToConfigureCaptureSession:
                return "We were unable to start the camera."
            }
        }
    }
}
