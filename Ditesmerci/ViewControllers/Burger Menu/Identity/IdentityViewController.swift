//
//  IdentityViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 09/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class IdentityViewController : UIViewController {
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    
    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "email"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.backgroundColor = .blueMerci
        label.textAlignment = .center

        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "*********"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.backgroundColor = .blueMerci
        label.textAlignment = .center

        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        return label
    }()
    
    lazy var modifiedImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "cadenas")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModified)))

        return imageView
    }()
    
    @objc private func handleModified(){
        print("try to modified")
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(ModifiedIdentityViewController(), animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()
        setupViews()
        fetchData()
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
            
            if let email = userInfo.email, let phoneNumber = userInfo.phoneNumber, let profileImageUrlThumbnail = userInfo.profileImageUrlThumbnail  {
                self.emailLabel.text = email
                self.phoneNumberLabel.text = phoneNumber
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
}
