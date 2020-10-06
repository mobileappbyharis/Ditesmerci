//
//  JobModifiedViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 16/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class JobModifiedViewController : UIViewController {
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var profileImageUrl = "none"
    var placeID = "none"
    
    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Emploi"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ajouter votre nouveau emploi"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let jobTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nouveau emploi"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        return textField
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blueMerci
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  ENVOYER  ", for: .normal)
        button.addTarget(self, action: #selector(handleSendNewJob), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    @objc private func handleSendNewJob(){
        print("try to send new email")
        guard let uid = auth.currentUser?.uid, let newJob = jobTextField.text else {
            self.displayAlertErrorUI(title: "Erreur", message: "Erreur lors de l'inscription du nouveau poste", answer: "ok")
            return
        }
        if newJob.isEmpty {
            print("edittext empty")
            self.displayAlertErrorUI(title: "Champ vide", message: "Remplissez le champ s'il vous plaît.", answer: "ok")
            return
        }
        
        self.db.collection("users").document(uid).setData([
            "job": newJob
        ], merge: true) { (error) in
            if let error = error {
                print("failed to store job to firestore: \(error)")
                return
            }
            if self.placeID != "none" {
                self.db.collection("users").document(uid).collection("jobs").document(self.placeID).setData([
                    "job": newJob
                ], merge: true) { (error) in
                    if let error = error {
                        print("failed to store job to firestore: \(error)")
                    } else {
                        print("success to store job to firestore")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        setupViews()
        if profileImageUrl != "none"{
            displayProfileImage(imageUrl: profileImageUrl, imageView: self.profileImageView)
        }
        
    }
    
    private func setupViews(){
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 130),
            profileImageView.widthAnchor.constraint(equalToConstant: 130)
            ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30),
            ])
        
        self.addConstraintFromView(subview: containerView, attribute: .centerY, multiplier: 1.15, identifier: "containerView placement Y")
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -90)
            ])

        setupContainerView()
    }
    
    private func setupContainerView(){
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(jobTextField)
        containerView.addSubview(dividerLineView)
        containerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            ])
        
        NSLayoutConstraint.activate([
            jobTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            jobTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            jobTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3),
            jobTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            ])
        
        NSLayoutConstraint.activate([
            dividerLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dividerLineView.topAnchor.constraint(equalTo: jobTextField.bottomAnchor, constant: 10),
            dividerLineView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.02),
            dividerLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            sendButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/6),
            ])
        
    }
    
    
}
