//
//  QRCodeViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 07/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseAuth


class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let captureSession = AVCaptureSession()
    var db = Firestore.firestore()
    var auth = Auth.auth()

    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-v1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    let displayProfilButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" mon Qr code ", for: .normal)
        button.addTarget(self, action: #selector(handleDisplayQrcode), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blueMerci
        return button
    }()
    
    @objc private func handleDisplayQrcode(){
        print("try to display qrcode")
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(MyQRCodeViewController(), animated: true)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupViews()
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            print(readableObject)
           
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
    }
    
    func found(code: String) {
        print(code)
        guard let uid = auth.currentUser?.uid else {return}
        if uid == code {return}
        db.collection("users").document(code).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("failed to get info employee uid: \(error)")
                return
            }
            
            guard let document = documentSnapshot?.data() else {return}
            
            let employeeInfo = UserInfo(dictionary: document)
            
            if let companyName = employeeInfo.jobCompanyName, let jobPlaceId = employeeInfo.jobPlaceId {
                self.db.collection("users").document(uid).collection("visited").document(jobPlaceId).setData([
                    "companyName": companyName,
                    "employeesPresentUid": FieldValue.arrayUnion([code]),
                    "timestampVisited": FieldValue.serverTimestamp()
                    ] as [String : Any], merge: true, completion: { (error) in
                        if let error = error {
                            print("failed to set visited data: \(error)")
                    
                        } else {
                            print("success to set visited data")
                            let giveViewController = GiveViewController()
                            giveViewController.employeeUid = code
                            let navController = UINavigationController(rootViewController: giveViewController)
                            DispatchQueue.main.async {
                                self.present(navController, animated: true, completion: nil)
                            }
                        }
                })
            }
        }
        
        
    }
    
    private func setupCamera(){
        let metadataOutput = AVCaptureMetadataOutput()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        captureSession.addInput(input)
        
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        captureSession.startRunning()

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        
 
        
    }
    
    private func setupTopLogoImageView(){
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            ])
        
    }
    private func setupViews(){
        setupTopLogoImageView()
        
        view.addSubview(displayProfilButton)

        NSLayoutConstraint.activate([
            displayProfilButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayProfilButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            ])
    }
    
    
}
