//
//  ForgotPasswordViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 03/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase


class ForgotPasswordViewController: UIViewController {
    
    let db = Firestore.firestore()
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
    let forgottenPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MOT DE PASSE OUBLIÉ"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Saisissez votre adresse e-mail \n pour recevoir les instructions"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
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
        button.setTitle("ENVOYER", for: .normal)
        button.addTarget(self, action: #selector(handleSendEmail), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    
    @objc private func handleSendEmail(){
        print("try to send email to get new password")
        if let email = emailTextField.text{
        
            if email.isEmpty {
                displayAlertErrorUI(title: "Error", message: "Ecrivez votre adresse email dans l'espace présenté.", answer: "ok")
                return
            }
        
            if isValidEmail(testStr: email) {
                resetPassword(email: email)
                return
            } else {
                displayAlertErrorUI(title: "Error", message: "L'email que vous avez entré n'est pas valide.", answer: "ok")
            }
        
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem
        view.backgroundColor = .white
        setupViews()
    }
    
    private func resetPassword(email: String){
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("error to send passwordreset mail: \(error)")
                return
            } else {
                print("success to sendPasswordReset")
                DispatchQueue.main.async {
                    self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                    self.navigationController?.pushViewController(CreateNewPasswordViewController(), animated: false)
                }
            }
        }
        
        
    }
    
    
    private func setupViews(){
        setupTopLogoImageView()
        setupMainView()
    }
    
    private func setupTopLogoImageView(){
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            ])
    }
    
    
    private func setupMainView() {
        view.addSubview(forgottenPasswordLabel)
        view.addSubview(containerView)
        
        
        self.addConstraintFromView(subview: forgottenPasswordLabel, attribute: .centerY, multiplier: 0.55, identifier: "forgottenPasswordLabel placement Y")
        
        NSLayoutConstraint.activate([
            forgottenPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        
        self.addConstraintFromView(subview: containerView, attribute: .centerY, multiplier: 0.98, identifier: "containerView placement Y")
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            ])
        
        containerView.addSubview(instructionsLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(dividerLineView)
        containerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            instructionsLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.35),
            instructionsLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor),
            emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.30),
            emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            dividerLineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            dividerLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dividerLineView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.02),
            dividerLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            ])
        
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.28)
            ])


    }
}
