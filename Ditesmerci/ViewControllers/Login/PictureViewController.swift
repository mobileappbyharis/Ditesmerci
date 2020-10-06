//
//  PictureViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 27/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var db: Firestore!
    
    let shapeLayer = CAShapeLayer()
    var alertController: UIAlertController?

    var isSelectedImage = false
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo-v1")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let firstIndicationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 13)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.text = "Votre meilleur profil,\n pour ne rater aucun 'Merci' "
        return textView
    }()
    
    lazy var cameraLogoImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cameracircle")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        return imageView
    }()
    
    lazy var sendImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "validate")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSend)))

        return imageView
    }()
    
    let ignoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  IGNORER POUR L'INSTANT  ", for: .normal)
        button.backgroundColor = .blueMerci
        button.addTarget(self, action: #selector(handleIgnore), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    let secondIndicationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 10)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.text = "Votre photo de profil pourra être ajoutée ultérieurement.\n En attendant vous pouvez envoyer des 'Merci' mais pas en recevoir."
        return textView
    }()
    
    
    @objc private func handleSend(){
        print("try to send photo")
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController!)
        
        if let user = Auth.auth().currentUser{
            let profileImage = cameraLogoImageView.image
            let uploadData = profileImage?.pngData()
            if isSelectedImage {
                if uploadData != nil {
                    if let profileImageThumbnail = cameraLogoImageView.image, let uploadDataThumbnail = profileImageThumbnail.jpegData(compressionQuality: 0.1) {
                        let storageRef = Storage.storage().reference().child("images").child("users").child((user.uid)).child("profileImage.png")
                        let storageRefThumbnail = Storage.storage().reference().child("images").child("users").child((user.uid)).child("profileImageThumbnail.jpg")
                        
                        storageRef.putData(uploadData!, metadata: nil, completion: {(metadata, error) in
                            if error != nil {
                                print(error ?? "didn't catch the error")
                                self.alertController?.dismiss(animated: true, completion: nil)
                                return
                            }
                            print(metadata ?? "didn't catch the metadata")
                            
                            storageRef.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                    // Uh-oh, an error occurred!
                                    self.alertController?.dismiss(animated: true, completion: nil)
                                    return
                                }
                                let imageProfileUrl = downloadURL.absoluteString
                                print("url : \(imageProfileUrl)")
                                
                                
                                
                                // ---- Thumbnail
                                
                                storageRefThumbnail.putData(uploadDataThumbnail, metadata: nil, completion: {(metadata, error) in
                                    if error != nil {
                                        print(error ?? "didn't catch the error")
                                        return
                                    }
                                    print(metadata ?? "didn't catch the metadata")
                                    
                                    storageRefThumbnail.downloadURL { (urlThumbnail, error) in
                                        guard let downloadURLThumbnail = urlThumbnail else {
                                            // Uh-oh, an error occurred!
                                            return
                                        }
                                        let imageProfileUrlThumbnail = downloadURLThumbnail.absoluteString
                                        
                                        let changeRequest = user.createProfileChangeRequest()
                                        changeRequest.photoURL = downloadURLThumbnail
                                        changeRequest.commitChanges { (error) in
                                            if let error = error {
                                                print("changeRequest failed \(error)")
                                                self.alertController?.dismiss(animated: true, completion: {
                                                    self.displayAlertErrorUI(title: "Erreur", message: "L'application a rencontrée un problème, réessayez dans quelques minutes.", answer: "ok")
                                                })
                                            } else {
                                                print("changeRequest succeed")
                                                self.db.collection("users").document(user.uid).setData([
                                                    "profileImageUrl": imageProfileUrl,
                                                    "profileImageUrlThumbnail": imageProfileUrlThumbnail,
                                                    ] as [String : Any], merge: true, completion: { err in
                                                        if let err = err {
                                                            print("Failed store userInfo: \(err)")
                                                            self.alertController?.dismiss(animated: true, completion: {
                                                                self.displayAlertErrorUI(title: "Erreur", message: "L'application a rencontrée un problème, réessayez dans quelques minutes.", answer: "ok")
                                                            })
                                                            
                                                        } else {
                                                            print("Succeed store userInfo")
                                                            self.alertController?.dismiss(animated: true, completion: {
                                                                let tabBarController = TabBarController()
                                                                tabBarController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                                                                self.present(tabBarController, animated: true, completion: nil)
                                                                
                                                            })
                                                        }
                                                })
                                            }
                                        }
                                    }
                                })
                            }
                            
                        })
                    } else {
                        print("problem image compression")
                        self.alertController?.dismiss(animated: true, completion: {
                            self.displayAlertErrorUI(title: "Erreur", message: "Problème lors de la compression de l'image.", answer: "ok")
                        })
                    }
                } else {
                    print("You have to choose an image")
                    self.alertController?.dismiss(animated: true, completion: {
                        self.displayAlertErrorUI(title: "Image", message: "Sélectionnez une image en cliquant sur le logo caméra.", answer: "ok")
                    })
                }
            
            } else {
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Image", message: "Sélectionnez une image en cliquant sur l'appareil photo.", answer: "ok")
                })

            }
        } else {
            self.alertController?.dismiss(animated: true, completion: {
                let showCaseViewController = ShowcaseViewController()
                let nav = UINavigationController(rootViewController: showCaseViewController)
                nav.interactivePopGestureRecognizer?.isEnabled = true
                nav.setNavigationBarHidden(true, animated: false)
                self.present(nav, animated: false, completion: nil)
            })
        }
    }
    
    
    
    
    @objc func handleIgnore(_ sender: UIButton) {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem
        view.backgroundColor = .white
        self.db = Firestore.firestore()
        setupViews()
        //setupCircle()
    }
    
    
    private func setupViews(){
        setupTopLogoImageView()
        view.addSubview(firstIndicationTextView)
        view.addSubview(cameraLogoImageView)
        view.addSubview(sendImageView)
        view.addSubview(ignoreButton)
        view.addSubview(secondIndicationTextView)
        
        self.addConstraintFromView(subview: firstIndicationTextView, attribute: .centerY, multiplier: 0.9, identifier: "firstIndicationTextView placement Y")
        
        NSLayoutConstraint.activate([
            firstIndicationTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstIndicationTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
            ])
        NSLayoutConstraint.activate([
            cameraLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
            cameraLogoImageView.widthAnchor.constraint(equalToConstant: 230),
            cameraLogoImageView.heightAnchor.constraint(equalToConstant: 230)
            ])
        
        self.addConstraintFromView(subview: sendImageView, attribute: .centerY, multiplier: 1.5, identifier: "sendButton placement Y")
        
        NSLayoutConstraint.activate([
            sendImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendImageView.widthAnchor.constraint(equalToConstant: 40),
            sendImageView.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        NSLayoutConstraint.activate([
            ignoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ignoreButton.bottomAnchor.constraint(equalTo: secondIndicationTextView.topAnchor, constant: -10),
            ])
        NSLayoutConstraint.activate([
            secondIndicationTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondIndicationTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            secondIndicationTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            secondIndicationTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
            ])
        
    }
    
    private func setupTopLogoImageView(){
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            ])
    }
    
    
    private func setupCircle(){
        let center = CGPoint(x: view.center.x, y: view.center.y + 10)
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(100), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor.purpleMerci.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        
        view.layer.addSublayer(shapeLayer)
    }
    
    //------ ImageView
    @objc private func handleSelectProfileImageView(){
        print("trying select image")
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController!)
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        self.alertController?.dismiss(animated: true, completion: {
            self.present(picker, animated: true, completion: nil)
        })
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            cameraLogoImageView.image = selectedImage
        }
        isSelectedImage = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    //------ ImageView
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
