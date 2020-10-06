//
//  RegisterViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 17/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftyJSON


class RegisterViewController: UIViewController, UITextFieldDelegate {
    

    var listenerRegistration: ListenerRegistration?
    var alertController: UIAlertController?
    
    var db = Firestore.firestore()
    
    private var datePicker: UIDatePicker?
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo-v1")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let formContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let createAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CRÉER VOTRE COMPTE"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nom"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Prénom"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
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
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Mot de passe"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        return textField
    }()
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Date de naissance"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
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
        button.setTitle("ENVOYER", for: .normal)
        button.addTarget(self, action: #selector(handleSendInfo), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let securityTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "En créant votre compte et votre fiche professionnelle sur 'Dites Merci' vous acceptez nos conditions d'utilisation, notre politique de confidentialité ainsi que notre politique de cookies."
        textView.font = UIFont.boldSystemFont(ofSize: 10)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem
        self.hideKeyboardWhenTappedAround()
        
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        birthdayTextField.inputView = datePicker

        
        setupViews()
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    private func setupViews(){
        view.backgroundColor = .white
        setupTopLogoImageView()
        setupFormContainerView()
        setupBottomViews()
    }
    
    private func CheckIfEmailIsUsed(email: String, lastName: String, firstName: String, birthday: TimeInterval, password: String){
        listenerRegistration = db.collection("users").whereField("email", isEqualTo: email).addSnapshotListener({ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if(snapshot.isEmpty){
                self.listenerRegistration?.remove()
                // User with this email does not exist yet
                print("User with this email does not exist yet")
                self.alertController?.dismiss(animated: true, completion: {
                    let phoneVerificationViewController = PhoneVerificationViewController()
                    phoneVerificationViewController.lastName = lastName
                    phoneVerificationViewController.firstName = firstName
                    phoneVerificationViewController.birthday = birthday
                    phoneVerificationViewController.email = email
                    phoneVerificationViewController.password = password
                    
                    
                    DispatchQueue.main.async {
                        self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                        self.navigationController?.pushViewController(phoneVerificationViewController, animated: false)
                    }
                })
                
            } else {
                self.listenerRegistration?.remove()
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Email déjà utilisé", message: "L'email que vous avez entré a déjà un compte.", answer: "ok")
                })
            }
        })
        
    }
    
    @objc private func handleSendInfo(){
        print("try to send info")
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController!)
        let email = emailTextField.text ?? "none"
        let password = passwordTextField.text ?? "none"
        let lastName = lastNameTextField.text ?? "none"
        let firstName = firstNameTextField.text ?? "none"
        let birthday = (self.datePicker?.date.timeIntervalSince1970)!
        
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "dd/MM/yyyy"
//        let showDate = inputFormatter.date(from: birthday)
//        inputFormatter.dateFormat = "yyyy-MM-dd"
//        let birthdate = inputFormatter.string(from: showDate!)
//        print(birthdate)
        
        // Check if TextField are not empty
        if(!email.isEmpty && !password.isEmpty && !lastName.isEmpty && !firstName.isEmpty && !birthdayTextField.text!.isEmpty){
            if(self.isValidEmail(testStr: email)) {
                if(password.count > 5) {
                    CheckIfEmailIsUsed(email: email, lastName: lastName, firstName: firstName, birthday: birthday, password: password)
                } else {
                    self.alertController?.dismiss(animated: true, completion: {
                        self.displayAlertErrorUI(title: "Mot de passe", message: "Votre mot de passe doit contenir plus de 6 caractères.", answer: "ok")
                    })
                }
            } else {
                print("Email is not valide")
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Email", message: "L'adresse email est invalide.", answer: "ok")
                })
            }
            
        } else {
            print("Didn't write all textfield")
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Erreur", message: "Remplissez tous les champs s'il vous plaît.", answer: "ok")
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == " ") {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == lastNameTextField){
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == lastNameTextField){
            return
        }
        // Keyboard up
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    // All views setup
    private func setupFormContainerView(){
        view.addSubview(formContainerView)
        
        formContainerView.addSubview(createAccountLabel)
        formContainerView.addSubview(lastNameTextField)
        formContainerView.addSubview(firstNameTextField)
        formContainerView.addSubview(birthdayTextField)
        formContainerView.addSubview(emailTextField)
        formContainerView.addSubview(passwordTextField)
        formContainerView.addSubview(dividerLineView)
        formContainerView.addSubview(sendButton)
        
        let factor = CGFloat(0.12)
        
        NSLayoutConstraint.activate([
            formContainerView.centerYAnchor.constraint(equalTo:view.centerYAnchor),
            formContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            formContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: paddingTextField(positive: true)),
            formContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: paddingTextField(positive: false)),
            formContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            ])
        
        NSLayoutConstraint.activate([
            createAccountLabel.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            createAccountLabel.topAnchor.constraint(equalTo: formContainerView.topAnchor),
            createAccountLabel.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            createAccountLabel.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            createAccountLabel.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.10)
            ])
        NSLayoutConstraint.activate([
            lastNameTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            lastNameTextField.topAnchor.constraint(equalTo: createAccountLabel.bottomAnchor, constant: 10),
            lastNameTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            lastNameTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: factor)
            ])
        NSLayoutConstraint.activate([
            firstNameTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            firstNameTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10),
            firstNameTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            firstNameTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            firstNameTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: factor)
            ])
        NSLayoutConstraint.activate([
            birthdayTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            birthdayTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 10),
            birthdayTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            birthdayTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            birthdayTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: factor)
            ])
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: birthdayTextField.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: factor)
            ])
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: factor)
            ])
        
        
        NSLayoutConstraint.activate([
            dividerLineView.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            dividerLineView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            dividerLineView.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            dividerLineView.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            dividerLineView.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.012)
            ])
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            sendButton.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            sendButton.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: factor)
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
    
    private func setupBottomViews(){
        view.addSubview(securityTextView)
        
        NSLayoutConstraint.activate([
            securityTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            securityTextView.topAnchor.constraint(equalTo: formContainerView.bottomAnchor),
            securityTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            securityTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            securityTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            ])
    }
    
    
    
}
