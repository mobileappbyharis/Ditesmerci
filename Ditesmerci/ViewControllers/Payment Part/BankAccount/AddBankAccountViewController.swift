//
//  AddBankAccountViewController.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 01/06/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase


class AddBankAccountViewController: UIViewController, UITextFieldDelegate {
    // TODO: Ajouter les textfield pour l'adresse (mettre une scrollView si nécessaire)
    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "FirstName Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Informations financières"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "AJOUTER UN COMPTE BANCAIRE"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .purpleMerci
        return label
    }()
    
    let formView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    let nameDetail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NOM COMPLET DU TITULAIRE"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "NOM ET PRÉNOM DU TITULAIRE"
        textField.layer.borderColor = UIColor.transparent.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        //textField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        return textField
    }()
    
    
    let libelleDetail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Libellé"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let libelleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Compte Perso"
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        //textField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        return textField
    }()
    
    let ibanDetail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "IBAN"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        
        return label
    }()
    
    let ibanTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "XX00 0000 0000 0000 0000 0000 0000"
        textField.layer.borderColor = UIColor.transparent.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center

        //textField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        return textField
    }()
    
    let addressDetail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Adresse"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let addressTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "75, rue henri barbusse"
        textField.layer.borderColor = UIColor.transparent.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        //textField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        return textField
    }()
    
    let cityDetail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ville"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let cityTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Paris"
        textField.layer.borderColor = UIColor.transparent.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        //textField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        return textField
    }()
    
    let postalCodeDetail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Code Postale"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let postalCodeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "75002"
        textField.layer.borderColor = UIColor.transparent.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.bezel
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numberPad
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        //textField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Enregistrer  ", for: .normal)
        button.addTarget(self, action: #selector(handleSendCreditCardInfo), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blueMerci
        return button
    }()
    
    
    lazy var functions = Functions.functions(region: "europe-west1")
    var auth = Auth.auth()
    var db = Firestore.firestore()
    var alertController: UIAlertController?
    
    var name = "none"
    var profileImageUrl = "none"
    
    var listenerRegistration : ListenerRegistration?
    
    
    @objc private func handleSendCreditCardInfo() {
        print("trying to send credit card informations")
        sendButton.isEnabled = false
        if ibanTextField.text?.count != 27 || nameTextField.text!.isEmpty {
            displayAlertErrorUI(title: "Erreur", message: "Remplissez correctement tous les champs s'il vous plaît.", answer: "OK")
            sendButton.isEnabled = true
            return
        }
        AddABankAccount()
    }
    
    func AddABankAccount() {
        // TODO: changer card en bankaccount
        self.displayWaitSpinner(alertController: alertController!)
        guard let addressline1 = addressTextField.text, let city = cityTextField.text, let postalCode = postalCodeTextField.text, let ownerName = nameTextField.text, let iban = ibanTextField.text else {return}
        functions.httpsCallable("createBankAccountMangoPay").call(["addressline1": addressline1, "city": city, "postalCode": postalCode, "ownerName": ownerName, "iban": iban]) { (result, error) in
            self.sendButton.isEnabled = true
            if let error = error as NSError? {
              if error.domain == FunctionsErrorDomain {
                let code = FunctionsErrorCode(rawValue: error.code)
                let message = error.localizedDescription
                let details = error.userInfo[FunctionsErrorDetailsKey]
                  print("code: \(String(describing: code))")
                  print("message: \(message)")
                  print("details: \(String(describing: details))")
                self.errorHappened()
              }
                self.errorHappened()
            }
            if let status = (result?.data as? [String: Any])?["status"] as? String {
              print("status : \(status)")
                if status == "SUCCEED" {
                    self.successHappened()
                } else {
                    self.errorHappened()
                }
            }
        }
    }
    
    func errorHappened(){
        DispatchQueue.main.async {
            self.alertController?.dismiss(animated: true, completion: {
              self.displayAlertErrorUI(title: "Erreur", message: "Une erreur est surevenue lors de l'enregistrement de votre compte bancaire.", answer: "OK")
            })
        }
    }
    
    func successHappened(){
        DispatchQueue.main.async {
          self.alertController?.dismiss(animated: true, completion: {
            self.displayAlertErrorUI(title: "Succès", message: "Votre compte bancaire a bien été ajouté.", answer: "OK")
          })
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == nameTextField){
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == nameTextField){
            return
        }
        // Keyboard up
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        setupViews()
        self.libelleTextField.delegate = self
        self.addressTextField.delegate = self
        self.cityTextField.delegate = self
        self.postalCodeTextField.delegate = self
        self.ibanTextField.delegate = self
        
        nameLabel.text = name
        if profileImageUrl != "none" {
            displayProfileImage(imageUrl: profileImageUrl, imageView: profileImageView)
        }
    }
    
    func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(formView)
        formView.addSubview(nameDetail)
        formView.addSubview(nameTextField)
        formView.addSubview(libelleDetail)
        formView.addSubview(libelleTextField)
        formView.addSubview(ibanDetail)
        formView.addSubview(ibanTextField)
        formView.addSubview(addressDetail)
        formView.addSubview(addressTextField)
        formView.addSubview(cityDetail)
        formView.addSubview(cityTextField)
        formView.addSubview(postalCodeDetail)
        formView.addSubview(postalCodeTextField)
        view.addSubview(sendButton)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            ])
        
        let constraintNameLabel = NSLayoutConstraint(item: nameLabel,
                                                          attribute: .centerX,
                                                          relatedBy: .equal,
                                                          toItem: view,
                                                          attribute: .centerX,
                                                          multiplier: 1.2,
                                                          constant: 0)
        constraintNameLabel.identifier = "nameLabel placement X"
        view.addConstraint(constraintNameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            ])

        let constrainTitleLabel = NSLayoutConstraint(item: titleLabel,
                                                     attribute: .centerX,
                                                     relatedBy: .equal,
                                                     toItem: view,
                                                     attribute: .centerX,
                                                     multiplier: 1.4,
                                                     constant: 0)
        constrainTitleLabel.identifier = "titleLabel placement X"
        view.addConstraint(constrainTitleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            formView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            formView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            formView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15),
            formView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
        ])
        
        NSLayoutConstraint.activate([
            nameDetail.topAnchor.constraint(equalTo: formView.topAnchor),
            nameDetail.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameDetail.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: formView.trailingAnchor),

        ])
        NSLayoutConstraint.activate([
            libelleDetail.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
            libelleDetail.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            libelleTextField.topAnchor.constraint(equalTo: libelleDetail.bottomAnchor),
            libelleTextField.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
            libelleTextField.trailingAnchor.constraint(equalTo: formView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            ibanDetail.topAnchor.constraint(equalTo: libelleTextField.bottomAnchor, constant: 5),
            ibanDetail.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            ibanTextField.topAnchor.constraint(equalTo: ibanDetail.bottomAnchor, constant: 5),
            ibanTextField.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            addressDetail.topAnchor.constraint(equalTo: ibanTextField.bottomAnchor, constant: 5),
            addressDetail.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            addressTextField.topAnchor.constraint(equalTo: addressDetail.bottomAnchor, constant: 5),
            addressTextField.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
            addressTextField.trailingAnchor.constraint(equalTo: formView.trailingAnchor),

        ])
        NSLayoutConstraint.activate([
            cityDetail.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 5),
            cityDetail.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: cityDetail.bottomAnchor),
            cityTextField.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
            cityTextField.trailingAnchor.constraint(equalTo: formView.trailingAnchor),

        ])
        NSLayoutConstraint.activate([
            postalCodeDetail.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 8),
            postalCodeDetail.leftAnchor.constraint(equalTo: formView.leftAnchor),
        ])
        NSLayoutConstraint.activate([
            postalCodeTextField.centerYAnchor.constraint(equalTo: postalCodeDetail.centerYAnchor),
            postalCodeTextField.leadingAnchor.constraint(equalTo: postalCodeDetail.trailingAnchor, constant: 5),
            postalCodeTextField.trailingAnchor.constraint(equalTo: formView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: postalCodeTextField.bottomAnchor, constant: 10),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
