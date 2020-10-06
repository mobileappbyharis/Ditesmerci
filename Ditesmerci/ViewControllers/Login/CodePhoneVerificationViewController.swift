//
//  PhoneVerificationCode.swift
//  Ditesmerci
//
//  Created by 7k04 on 20/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

class CodePhoneVerificationViewController: UIViewController {
    var alertController: UIAlertController?
    
    var db: Firestore!
    
    var lastName: String?
    var firstName: String?
    var birthday: TimeInterval?
    var birthCountry: String?
    var birthCity: String?
    var email: String?
    var password: String?
    var phoneNumber: String?
    
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
    
    let codeVerificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SAISIR LE CODE REÇU"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        
        return label
        
    }()
    
    let codeVerificationTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "CODE REÇU PAR SMS"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.keyboardType = UIKeyboardType.numberPad
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.backgroundColor = .clear
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    let dividerLineView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor.blueMerci
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    let verificationCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("VÉRIFIER", for: .normal)
        button.addTarget(self, action: #selector(handleSendCodeVerification), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let resendCodeVerificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Code non reçu,\n envoyer de nouveau", for: .normal)
        button.backgroundColor = .blueMerci
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleResendCodeVerification), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    
    private func sendUserInfoToFirestore(email: String, firstName: String, lastName: String, birthday: TimeInterval, phoneNumber: String, uid: String){
        self.db.collection("users").document(uid).setData([
            "amountPourboire": Double(0),
            "birthday": Int(birthday),
            "email": email,
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
            "phoneNumber": phoneNumber,
            "profileImageUrl": "none",
            "profileImageUrlThumbnail": "none",
            "reviewNumber": 0,
            "thanks": 0,
            "timestampCreationAccount": FieldValue.serverTimestamp(),
            "timestampLastGpsDetection": FieldValue.serverTimestamp(),
            "timestampModification": FieldValue.serverTimestamp(),
            "timestampPresent": FieldValue.serverTimestamp(),
            "uid": uid,
            ] as [String : Any], merge: true, completion: { err in
                if let err = err {
                    print("Failed store userInfo: \(err)")
                    self.alertController?.dismiss(animated: true, completion: nil)
                    
                } else {
                    print("Succeed store userInfo")
                    self.alertController?.dismiss(animated: true, completion: nil)
                    let vc = ProFormViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    
                }
        })
    }
    
    private func registerNewUser(email: String, password: String, lastName: String, firstName: String, birthday: TimeInterval){
        let auth = Auth.auth()
        let defaults = UserDefaults.standard
        guard let code = codeVerificationTextField.text else { return }
        guard let verificationID = defaults.string(forKey: "authVID") else { return }
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        
        auth.signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("error: \(String(describing: error))")
                self.alertController?.dismiss(animated: true, completion: {
                    if let errCode = AuthErrorCode(rawValue: error._code){
                        if(errCode.rawValue == 17044){
                            self.displayAlertErrorUI(title: "Erreur", message: "Le numéro de vérification ne correspond pas à celui envoyer par SMS.", answer: "ok")
                        } else {
                            self.displayAlertErrorUI(title: "Erreur", message: "Le numéro de téléphone que vous avez entré est déjà utilisé par un autre compte.", answer: "ok")
                        }
                    }
                })
                return
            }
            print("user created with phone: \(self.phoneNumber ?? "none")")
            if let user = authResult?.user {
                let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                
                user.link(with: credential, completion: { (authResult, error) in
                    if let error = error {
                        self.alertController?.dismiss(animated: true, completion: {
                            print("error sign in with email : \(error.localizedDescription)")
                        })
                    return
                    }
                    
                    print("user link with email: \(email)")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = firstName
                    changeRequest?.commitChanges { (error) in
                        if error != nil {
                            self.alertController?.dismiss(animated: true, completion: nil)
                            print("Change request displayName error : \(error?.localizedDescription as Optional)")
                            return
                        }
                        print("Change request displayName succeed")
                        user.updateEmail(to: email) { (error) in
                            if let error = error {
                                print("changeRequest email failed \(error)")
                                self.alertController?.dismiss(animated: true, completion: nil)
                                return
                            }
                            print("changeRequest email succeed")
                            self.alertController?.dismiss(animated: true, completion: {
                                user.sendEmailVerification { (error) in
                                    print("email verification sent!")
                                    self.sendUserInfoToFirestore(email: email, firstName: firstName, lastName: lastName, birthday: birthday, phoneNumber: self.phoneNumber!, uid: user.uid)
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    
    @objc private func handleSendCodeVerification(){
        print("try to send code verification")
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController!)
        registerNewUser(email: email!, password: password!, lastName: lastName!, firstName: firstName!, birthday: birthday!)
    }
    
    @objc private func handleResendCodeVerification(){
        print("try to resend code verification")
        
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController!)
        
        guard let phoneNumber = self.phoneNumber else { return }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
                
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Erreur", message: "Vous avez tenté de vous authentifier trop de fois, patientez 5minutes puis réessayez s'il vous plaît", answer: "ok")
                })
                
            } else {
                let defaults = UserDefaults.standard
                defaults.set(verificationID, forKey: "authVID")
                self.alertController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Two line text inside a button
        resendCodeVerificationButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem
        self.hideKeyboardWhenTappedAround()
        self.db = Firestore.firestore()
        
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        setupTopLogoImageView()
        setupFormContainerView()
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
        view.addSubview(formContainerView)
        //formContainerView.backgroundColor = .green
        formContainerView.addSubview(codeVerificationLabel)
        formContainerView.addSubview(codeVerificationTextField)
        formContainerView.addSubview(dividerLineView)
        formContainerView.addSubview(verificationCodeButton)
        formContainerView.addSubview(resendCodeVerificationButton)
        
        self.addConstraintFromView(subview: formContainerView, attribute: .centerY, multiplier: 1.2, identifier: "formContainerView placement Y")
        NSLayoutConstraint.activate([
            formContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            formContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: paddingTextField(positive: true)),
            formContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: paddingTextField(positive: false)),
            formContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
            ])
        NSLayoutConstraint.activate([
            codeVerificationLabel.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            codeVerificationLabel.topAnchor.constraint(equalTo: formContainerView.topAnchor),
            codeVerificationLabel.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            codeVerificationLabel.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            codeVerificationLabel.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.14),
            ])
        NSLayoutConstraint.activate([
            codeVerificationTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            codeVerificationTextField.topAnchor.constraint(equalTo: codeVerificationLabel.bottomAnchor),
            codeVerificationTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            codeVerificationTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            codeVerificationTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.18),
            ])
        NSLayoutConstraint.activate([
            dividerLineView.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            dividerLineView.topAnchor.constraint(equalTo: codeVerificationTextField.bottomAnchor, constant: 10),
            dividerLineView.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            dividerLineView.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            dividerLineView.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.012)
            ])
        NSLayoutConstraint.activate([
            verificationCodeButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            verificationCodeButton.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            verificationCodeButton.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.14)
            ])
        
        NSLayoutConstraint.activate([
            resendCodeVerificationButton.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            resendCodeVerificationButton.bottomAnchor.constraint(equalTo: formContainerView.bottomAnchor, constant: -12),
            resendCodeVerificationButton.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.15),
            resendCodeVerificationButton.widthAnchor.constraint(equalTo: formContainerView.widthAnchor, multiplier: 0.45)
            
            ])
        
        
    }
    
    
}
