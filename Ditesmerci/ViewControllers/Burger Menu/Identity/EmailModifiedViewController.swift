//
//  EmailModifiedViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 14/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class EmailModifiedViewController: UIViewController, UITextFieldDelegate {
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var profileImageUrl = "none"
    
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
        label.text = "Adresse e-mail"
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
        label.text = "Ajouter une nouvelle adresse e-mail"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "E-mail"
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
        button.addTarget(self, action: #selector(handleSendNewEmail), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    //TODO: Add 2 textfield with email and password
    
    
    private func reAuthenticateUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
        }
    }
    
    @objc private func handleSendNewEmail(){
        print("try to send new email")
        guard let user = auth.currentUser, let uid = auth.currentUser?.uid, let newEmail = emailTextField.text else {
            self.displayAlertErrorUI(title: "Erreur", message: "Erreur lors de l'inscription de la nouvelle adresse e-mail", answer: "ok")
            return
        }
        if newEmail.isEmpty {
            print("edittext empty")
            self.displayAlertErrorUI(title: "Champ vide", message: "Remplissez le champ s'il vous plaît.", answer: "ok")
            return
        }
        
        if !isValidEmail(testStr: newEmail) {
            print("email not good")
            self.displayAlertErrorUI(title: "E-mail invalide", message: "L'adresse email est invalide.", answer: "ok")
            return
        }

        user.updateEmail(to: newEmail) { (error) in
            if let error = error {
                print("error update email : \(error.localizedDescription)")
                self.displayAlertErrorUI(title: "Erreur", message: "Une erreur est survenue lors de la mise à jour de l'e-mail.", answer: "ok")
                return
            }
            self.db.collection("users").document(uid).setData([
                "email": newEmail
                ] as [String: Any], merge: true, completion: { (error) in
                if let error = error {
                    print("failed to store new email on firestore: \(error)")
                    return
                }
                user.sendEmailVerification { (error) in
                    if let error = error {
                        print("failed to send email verification to the new email : \(error)")
                    } else {
                        print("success to send email verification.")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
            
            
        }
    }
    
    
    let firstIndicationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.text = "Vous allez recevoir un mail comprenant un lien \n de vérification, merci de cliquer dessus \n pour confirmer votre nouvelle adresse"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()

        self.hideKeyboardWhenTappedAround()
        emailTextField.delegate = self

        setupViews()
        if profileImageUrl != "none"{
            displayProfileImage(imageUrl: profileImageUrl, imageView: self.profileImageView)
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == " ") {
            return false
        }
        return true
    }
    
    private func setupViews(){
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        view.addSubview(firstIndicationTextView)
        
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
        
        NSLayoutConstraint.activate([
            firstIndicationTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstIndicationTextView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            firstIndicationTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/6),
            ])
        
        setupContainerView()
    }
    
    private func setupContainerView(){
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(dividerLineView)
        containerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            ])
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3),
            emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            ])
        
        NSLayoutConstraint.activate([
            dividerLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dividerLineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
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
