//
//  QRCodeViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 29/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import AVFoundation

class QRcodeViewControllerTrain: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    

    
    var stringURL = String()
    
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupQRcode()
        
    }
    
    func setupQRcode() {
        do {
            try scanQRCode()
        } catch {
            print("Failed to scan the QR/Barcode.")
        }
    }
    
    
    func scanQRCode() throws {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        let input = try AVCaptureDeviceInput(device: captureDevice)
        
        // Set the input device on the capture session.
        captureSession.addInput(input)
        
        
        
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        // Start video capture.
        captureSession.startRunning()
    }

    
    
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        if metadataObjects.count > 0 {
//            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//
//            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
//                stringURL = machineReadableCode.stringValue!
//                print(stringURL)
//            }
//        }
//    }

}

