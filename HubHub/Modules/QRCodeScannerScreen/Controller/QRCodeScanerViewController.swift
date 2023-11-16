//
//  QRCodeScanerViewController.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 27.10.2023.
//

import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func loadView() {
        super.loadView()
        
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
    }

    private func configureScanner() {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            showAlert(message: "Your device does not have a camera.")
            return
        }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            showAlert(message: "Unable to access the camera.")
            return
        }

        guard captureSession.canAddInput(videoInput) else {
            showAlert(message: "Unable to configure camera input.")
            return
        }

        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()

        guard captureSession.canAddOutput(metadataOutput) else {
            showAlert(message: "Unable to configure scanner output.")
            return
        }

        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        configurePreviewLayer()
    }

    private func configurePreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)

        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds

        captureSession.startRunning()
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(
            title: "Scanning not supported",
            message: message,
            preferredStyle: .alert
        )
        
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        let alertView = alertController.view
        alertView?.tintColor = currentTheme.tintColor
//        alertView?.subviews.first?.subviews.first?.subviews.first?.backgroundColor = currentTheme.backgroundColor

        present(alertController, animated: true)
    }
}

extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let qrCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let codeValue = qrCode.stringValue {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            handleScannedCode(codeValue)
        }
    }

    private func handleScannedCode(_ code: String) {
        guard let url = URL(string: code) else { return }

        let userLogin = url.lastPathComponent
        navigationController?.pushViewController(UserProfileViewController(login: userLogin), animated: true)
    }
}

// MARK: - Navigatoin bar
extension QRCodeScannerViewController {
    private func configureNavigationBar() {
        title = "Scanner"
        navigationItem.largeTitleDisplayMode = .never
    }
}

extension QRCodeScannerViewController: Themeable {
    func applyTheme() {
        view.backgroundColor = currentTheme.backgroundColor
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
    }
}
