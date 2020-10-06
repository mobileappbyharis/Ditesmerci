//
//  CreateNewPasswordViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 04/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase


class CreateNewPasswordViewController: UIViewController, UITextFieldDelegate {
    
    let auth = Auth.auth()
    
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-v1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let createYourPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CRÉER VOTRE NOUVEAU MOT DE PASSE"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Règles de sécurité pour le mot \n de passe (chiffres, symboles...)"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = .black
        return label
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
    
    let blankView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let validateNewPasswordTextField: UITextField = {
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
    
    let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("RÉINITIALISER LE MOT DE PASSE", for: .normal)
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    @objc private func handleResetPassword(){
        print("try to reset password")
        if let newPassword = newPasswordTextField.text, let validatePassword = validateNewPasswordTextField.text  {
            if newPassword.isEmpty && validatePassword.isEmpty {
                displayAlertErrorUI(title: "Erreur", message: "Remplissez tous les champs s'il vous plaît.", answer: "ok")
                return
            }
            
            if newPassword.count < 5 {
                displayAlertErrorUI(title: "Erreur", message: "Votre mot de passe doit contenir plus de 6 caractères..", answer: "ok")
                return
            }
            
            if newPassword != validatePassword {
                displayAlertErrorUI(title: "Erreur", message: "Les mots de passes ne sont pas identiques.", answer: "ok")
                return
            }
            
            resetPassword(password: newPassword)
            
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        newPasswordTextField.delegate = self
        validateNewPasswordTextField.delegate = self
        setupViews()
    }
    
    
    private func resetPassword(password: String){
        auth.currentUser?.updatePassword(to: password) { (error) in
            if let error = error {
                print("failed to reset password: \(error)")
                return
            } else {
                print("succeed to reset password")
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
        if(textField == newPasswordTextField){
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == newPasswordTextField){
            return
        }
        // Keyboard up
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    private func setupViews(){
        setupTopLogoImageView()
        setupMainView()
    }
    
    private func setupMainView(){
        view.addSubview(createYourPasswordLabel)
        view.addSubview(containerView)
        
        self.addConstraintFromView(subview: createYourPasswordLabel, attribute: .centerY, multiplier: 0.55, identifier: "createYourPasswordLabel placement Y")
        
        NSLayoutConstraint.activate([
            createYourPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        
        
        self.addConstraintFromView(subview: containerView, attribute: .centerY, multiplier: 1.1, identifier: "containerView placement Y")
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            ])
        
        
        containerView.addSubview(instructionsLabel)
        containerView.addSubview(newPasswordTextField)
        containerView.addSubview(blankView)
        containerView.addSubview(validateNewPasswordTextField)
        containerView.addSubview(dividerLineView)
        containerView.addSubview(resetPasswordButton)
        
        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            instructionsLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            instructionsLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.20),
            ])
        
        NSLayoutConstraint.activate([
            newPasswordTextField.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor),
            newPasswordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            newPasswordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.18),
            ])
        
        NSLayoutConstraint.activate([
            blankView.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor),
            blankView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            blankView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.13),
            ])
        
        NSLayoutConstraint.activate([
            validateNewPasswordTextField.topAnchor.constraint(equalTo: blankView.bottomAnchor),
            validateNewPasswordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            validateNewPasswordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.18),
            ])
        
        NSLayoutConstraint.activate([
            dividerLineView.topAnchor.constraint(equalTo: validateNewPasswordTextField.bottomAnchor, constant: 10),
            dividerLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dividerLineView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.02),
            dividerLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            ])
        
        NSLayoutConstraint.activate([
            resetPasswordButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            resetPasswordButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            resetPasswordButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.1)
            ])
        

    }
    
    
    private func setupTopLogoImageView(){
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            ])
    }
    
    
 
}
