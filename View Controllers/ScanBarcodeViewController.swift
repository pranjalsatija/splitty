//
//  ScanBarcodeViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 9/23/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: ScanBarcodeViewControllerDelegate
protocol ScanBarcodeViewControllerDelegate: class {
    func scanBarcodeViewControllerDidCancel(_ scanBarcodeViewController: ScanBarcodeViewController)
}

// MARK: Base Class
class ScanBarcodeViewController: UIViewController, StoryboardInstantiatable {
    weak var delegate: ScanBarcodeViewControllerDelegate?

    private var cameraController = CameraController()
    private var state: State = .waitingForBarcode {
        didSet { update() }
    }

    private var shouldDisplayPreview = true

    @IBOutlet weak private var cameraPreviewView: UIView!
    @IBOutlet weak private var statusLabel: UILabel!

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: Setup
extension ScanBarcodeViewController {
    override func viewDidLoad() {
        do {
            try cameraController.configure()
        } catch {
            showError(error)
            Log.error(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        guard shouldDisplayPreview else {
            return
        }

        cameraController.delegate = self
        cameraController.displayPreview(on: cameraPreviewView)
        shouldDisplayPreview = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func update() {
        cameraController.resetScannedCodes()
        switch state {
        case .scanned(let barcode):
            statusLabel.text = "Scanned \(barcode), loading product info..."
            UISelectionFeedbackGenerator().selectionChanged()
        case .waitingForBarcode:
            statusLabel.text = "Waiting for barcode..."
        }
    }
}

// MARK: User Interaction
private extension ScanBarcodeViewController {
    @IBAction func cancelButtonPressed() {
        delegate?.scanBarcodeViewControllerDidCancel(self)
    }
}

// MARK: CameraControllerDelegate
extension ScanBarcodeViewController: CameraControllerDelegate {
    func cameraController(_ cameraController: CameraController, didOutputMachineReadableCode code: String) {
        state = .scanned(barcode: code)
    }
}

// MARK: State
extension ScanBarcodeViewController {
    enum State {
        case scanned(barcode: String)
        case waitingForBarcode
    }
}
