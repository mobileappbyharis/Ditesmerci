//
//  LoginViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 17/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var alertController: UIAlertController?
    
    var db = Firestore.firestore()

    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo-v1")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let formContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "IDENTIFIANT"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        
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
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        return textField
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MOT DE PASSE"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "************"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blueMerci
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let connexionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  CONNEXION  ", for: .normal)
        button.addTarget(self, action: #selector(handleConnexion), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let forgottenPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Mot de passe oublié  ", for: .normal)
        button.backgroundColor = .blueMerci
        button.addTarget(self, action: #selector(handleForgottenPassword), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private func sendUserInfoToFirestore(email: String, firstName: String, lastName: String, profileImageUrl: String, id: String, uid: String){
        self.db.collection("users").document(uid).setData([
            "email":  email,
            "firstName": firstName,
            "firstNameLowercase": firstName.lowercased(),
            "gpsLastLocation": GeoPoint(latitude: 1, longitude: 1),
            "isConnected": false,
            "isPresent": false,
            "isPro": false,
            "isShowcase": false,
            "job": "none",
            "jobCompanyName": "none",
            "jobFormattedAddress": "none",
            "jobGpsLocation": GeoPoint(latitude: 1, longitude: 1),
            "jobGpsRadius": "none",
            "jobPlaceId": "none",
            "jobSector": "none",
            "lastName": lastName,
            "lastNameLowercase": lastName.lowercased(),
            "notificationTokens": Messaging.messaging().fcmToken ?? "none",
            "phoneNumber": "none",
            "profileImageUrl": profileImageUrl,
            "profileImageUrlThumbnail": profileImageUrl,
            "reviewNumber": 0,
            "thanks": 0,
            "timestampCreationAccount": FieldValue.serverTimestamp(),
            "timestampLastGpsDetection": FieldValue.serverTimestamp(),
            "timestampModification": FieldValue.serverTimestamp(),
            "timestampPresent": FieldValue.serverTimestamp(),
            "uid": uid,
            "uidLinkedin": id
            ] as [String : Any], merge: true, completion: { err in
                if let err = err {
                    print("Failed store userInfo: \(err)")
                    self.alertController?.dismiss(animated: true, completion: nil)
                    
                } else {
                    print("Succeed store userInfo")
                    self.alertController?.dismiss(animated: true, completion: {
                        let proFormViewController = ProFormViewController()
                        proFormViewController.isAlreadyProfileImage = true
                        self.present(proFormViewController, animated: true, completion: nil)
                    })
                }
        })
    }

    
    @objc private func handleConnexion(){
        print("try to log in")
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController!)
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if(!email.isEmpty && !password.isEmpty){
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard let strongSelf = self else { return }
                
                if let error = error {
                    print("error: \(String(describing: error))")
                    strongSelf.alertController?.dismiss(animated: true, completion: {
                        strongSelf.displayAlertErrorUI(title: "Erreur", message: "Erreur lors de la connexion au compte.", answer: "ok")
                    })
                }
                
                strongSelf.alertController?.dismiss(animated: true, completion: {
                    let tabBarController = TabBarController()
                    tabBarController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                    strongSelf.present(tabBarController, animated: false, completion: nil)
                })
            }
        } else {
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Erreur", message: "Remplissez tous les champs s'il vous plaît.", answer: "ok")
            })
        }
        
    }
    
    @objc private func handleForgottenPassword(){
        print("try to forgotten password")
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem
        view.backgroundColor = .white
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupViews()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == emailTextField){
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == emailTextField){
            return
        }
        // Keyboard up
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        setupTopLogoImageView()
        setupFormContainerView()
        setupForgottenPasswordButtonView()
        
    }
    
    private func setupForgottenPasswordButtonView(){
        view.addSubview(forgottenPasswordButton)
        NSLayoutConstraint.activate([
            forgottenPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgottenPasswordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            forgottenPasswordButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04)
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
    
    private func setupFormContainerView(){
        view.addSubview(formContainer)
        
        formContainer.addSubview(emailLabel)
        formContainer.addSubview(emailTextField)
        formContainer.addSubview(passwordLabel)
        formContainer.addSubview(passwordTextField)
        formContainer.addSubview(dividerLineView)
        formContainer.addSubview(connexionButton)
        
        
        
        
        NSLayoutConstraint.activate([
            formContainer.centerYAnchor.constraint(equalTo:view.centerYAnchor),
            formContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            formContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: paddingTextField(positive: true)),
            formContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: paddingTextField(positive: false)),
            formContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            ])
        
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor),
            emailLabel.topAnchor.constraint(equalTo: formContainer.topAnchor),
            emailLabel.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 0.15)
            ])
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor),
            emailTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 0.15)
            ])
        NSLayoutConstraint.activate([
            passwordLabel.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor),
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordLabel.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 0.15)
            ])
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 0.15)
            ])
        NSLayoutConstraint.activate([
            dividerLineView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            dividerLineView.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor),
            dividerLineView.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor),
            dividerLineView.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 0.012)
            ])
        NSLayoutConstraint.activate([
            connexionButton.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor),
            connexionButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            connexionButton.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 0.15)
            ])        
    }
}
