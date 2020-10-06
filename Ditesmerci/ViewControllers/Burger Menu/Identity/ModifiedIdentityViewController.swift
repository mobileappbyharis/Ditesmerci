//
//  ModifiedIdentityViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 09/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ModifiedIdentityViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profileViewController: ProfileViewController?

    var db = Firestore.firestore()
    var auth = Auth.auth()
    var alertController: UIAlertController?
    var isSelectedImage = false
    var profileImageUrl = "none"
    var lastName = "none"
    var firstName = "none"
    
    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageModified)))

        return imageView
    }()
    
    @objc private func handleProfileImageModified(){
        print("try to modified profileImage")
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        

        self.present(picker, animated: true)
    }
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "email"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEmailModified)))

        return label
    }()
    
    @objc private func handleEmailModified(){
        print("try to modified email")
        let emailModifiedViewController = EmailModifiedViewController()
        if profileImageUrl != "none"{
            emailModifiedViewController.profileImageUrl = self.profileImageUrl
        }
        
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(emailModifiedViewController, animated: true)
        }
    }
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "*********"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePasswordModified)))

        return label
    }()
    @objc private func handlePasswordModified(){
        print("try to modified password")
        DispatchQueue.main.async {
           let passwordModifiedViewController = PasswordModifiedViewController()
            if self.profileImageUrl != "none" {
                passwordModifiedViewController.profileImageUrl = self.profileImageUrl
            }
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(passwordModifiedViewController, animated: true)
        }
    }
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePhoneNumberModified)))

        return label
    }()
    
    @objc private func handlePhoneNumberModified(){
        print("try to modified phone number")
        let phoneNumberModifiedViewController = PhoneNumberModifiedViewController()
        if self.profileImageUrl != "none" {
            phoneNumberModifiedViewController.profileImageUrl = self.profileImageUrl
        }
        
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(phoneNumberModifiedViewController, animated: true)
        }
    }
    
    lazy var modifiedImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "validate")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleValidate)))
        return imageView
    }()
    
    @objc private func handleValidate() {
        print("try to validate")
        navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileViewController?.boolBurger = true
    }

    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()
        setupViews()
        fetchData()
        emailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEmailModified)))
        passwordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePasswordModified)))
        phoneNumberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePhoneNumberModified)))
    }
    
    
    
    
    private func fetchData(){
        guard let uid = auth.currentUser?.uid else {return}
        
        db.collection("users").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("failed to get userInfo: \(error)")
                return
            }
            
            guard let document = documentSnapshot?.data() else {return}
            
            let userInfo = UserInfo(dictionary: document)
            if let firstName = userInfo.firstName, let lastName = userInfo.lastName {
                self.firstName = firstName
                self.lastName = lastName
            }
            
            if let email = userInfo.email, let phoneNumber = userInfo.phoneNumber, let profileImageUrlThumbnail = userInfo.profileImageUrlThumbnail  {
                self.emailLabel.text = email
                self.phoneNumberLabel.text = phoneNumber
                self.profileImageUrl = profileImageUrlThumbnail
                self.displayProfileImage(imageUrl: profileImageUrlThumbnail, imageView: self.profileImageView)
            }
        }
    }
    
    private func setupViews(){
        view.addSubview(profileImageView)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(modifiedImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 130),
            profileImageView.widthAnchor.constraint(equalToConstant: 130)
            ])
        
        NSLayoutConstraint.activate([
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            emailLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor),
            passwordLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            passwordLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            phoneNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneNumberLabel.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            phoneNumberLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            phoneNumberLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            modifiedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modifiedImageView.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: -10),
            modifiedImageView.heightAnchor.constraint(equalToConstant: 50),
            modifiedImageView.widthAnchor.constraint(equalToConstant: 50)
            ])
        
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
            profileImageView.image = selectedImage
            let profileImage = profileImageView.image
            if let uploadData = profileImage?.pngData() {
                uploadImageStorage(uploadData: uploadData)
            }
        }
        
        self.isSelectedImage = true
        self.dismiss(animated: true, completion: nil)

    }
    
    private func uploadImageStorage(uploadData: Data){
        guard let user = auth.currentUser, let uid = auth.currentUser?.uid, let profileImageThumbnail = profileImageView.image, let uploadDataThumbnail = profileImageThumbnail.jpegData(compressionQuality: 0.1) else {return}
        
            let storage = Storage.storage()
            let storageRef = storage.reference().child("images").child("users").child(uid).child("profileImage")
            let storageRefThumbnail = storage.reference().child("images").child("users").child(uid).child("profileImageThumbnail")
            
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error ?? "didn't catch the error")
                    return
                }
                print(metadata ?? "didn't catch the metadata")
                
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
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
                                    self.displayAlertErrorUI(title: "Erreur", message: "L'application a rencontrée un problème, réessayez dans quelques minutes.", answer: "ok")
                                } else {
                                    print("changeRequest succeed")
                                    self.db.collection("users").document(uid).setData([
                                        "profileImageUrl": imageProfileUrl,
                                        "profileImageUrlThumbnail": imageProfileUrlThumbnail,
                                        ] as [String : Any], merge: true, completion: { err in
                                            if let err = err {
                                                print("Failed store userInfo: \(err)")
                                                self.displayAlertErrorUI(title: "Erreur", message: "L'application a rencontrée un problème, réessayez dans quelques minutes.", answer: "ok")
                                                
                                            } else {
                                                print("Succeed store userInfo")
                                                
                                            }
                                    })
                                }
                            }
                        }
                    })
                }
            })
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    //------ ImageView

// Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

}
