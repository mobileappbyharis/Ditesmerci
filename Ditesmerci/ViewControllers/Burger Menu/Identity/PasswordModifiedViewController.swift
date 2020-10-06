//
//  PasswordModifiedViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 14/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PasswordModifiedViewController: UIViewController, UITextFieldDelegate {
    
    var auth = Auth.auth()
    var profileImageUrl = "none"
    var alertController: UIAlertController?

    
    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        
        return imageView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    let blankView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    let blank2View: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mot de passe"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Mot de passe actuel"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        return textField
    }()
    
    let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nouveau mot de passe"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        return textField
    }()
    
    let againNewPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Confirmer le nouveau mot de passe"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
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
        button.addTarget(self, action: #selector(handleSendNewPassword), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    
    
    @objc private func handleSendNewPassword(){
        print("send new password")
        self.displayWaitSpinner(alertController: alertController!)
        guard let user = auth.currentUser, let oldPassword = passwordTextField.text, let newPassword = newPasswordTextField.text, let againNewPassword = againNewPasswordTextField.text else {
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Erreur", message: "Erreur lors du changement du mot de passe.", answer: "ok")
            })
            return
        }
        if oldPassword.isEmpty || newPassword.isEmpty || againNewPassword.isEmpty {
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Erreur", message: "Remplissez correctement tous les champs s'il vous plaît.", answer: "ok")
            })
            return
        }
        if newPassword.count < 6 {
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Mot de passe", message: "Votre mot de passe doit contenir plus de 6 caractères.", answer: "ok")
            })
            return
        }
        if newPassword != againNewPassword {
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Mot de passe", message: "Les mots de passes ne correspondent pas.", answer: "ok")
            })
            return
        }
        
        user.updatePassword(to: newPassword) { (error) in
            if let error = error {
                print("failed to change the password: \(error)")
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Erreur", message: "Une erreur est surevenue, réessayez plus tard.", answer: "ok")
                })
            } else {
                print("success to change password!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == " ") {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if(textField == lastNameTextField){
//            return
//        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if(textField == lastNameTextField){
//            return
//        }
        // Keyboard up
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.hideKeyboardWhenTappedAround()
        passwordTextField.delegate = self
        newPasswordTextField.delegate = self
        againNewPasswordTextField.delegate = self

        if profileImageUrl != "none"{
            self.displayProfileImage(imageUrl: profileImageUrl, imageView: profileImageView)
        }
        setupViews()
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
        
         self.addConstraintFromView(subview: containerView, attribute: .centerY, multiplier: 1.20, identifier: "containerView placement Y")

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -90)
            ])
            
        setupContainerView()
    }
    
    private func setupContainerView(){
        containerView.addSubview(passwordTextField)
        containerView.addSubview(blankView)
        containerView.addSubview(newPasswordTextField)
        containerView.addSubview(blank2View)
        containerView.addSubview(againNewPasswordTextField)
        containerView.addSubview(dividerLineView)
        containerView.addSubview(sendButton)


        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.2),
            passwordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            blankView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            blankView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            blankView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.15),
            blankView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            newPasswordTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            newPasswordTextField.topAnchor.constraint(equalTo: blankView.bottomAnchor),
            newPasswordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.2),
            newPasswordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            blank2View.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            blank2View.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor),
            blank2View.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.15),
            blank2View.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            againNewPasswordTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            againNewPasswordTextField.topAnchor.constraint(equalTo: blank2View.bottomAnchor),
            againNewPasswordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.2),
            againNewPasswordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            dividerLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dividerLineView.topAnchor.constraint(equalTo: againNewPasswordTextField.bottomAnchor, constant: 10),
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
