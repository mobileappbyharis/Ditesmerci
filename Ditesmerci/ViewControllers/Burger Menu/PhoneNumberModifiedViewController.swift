//
//  PhoneNumberModifiedViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 14/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PhoneNumberModifiedViewController: UIViewController, UITextFieldDelegate {
    var alertController: UIAlertController?

    var auth = Auth.auth()
    var profileImageUrl = "none"
    

    
    // Animated Line
    let shapeLayer = CAShapeLayer()
    var offset: CGFloat = 0
    var previousCharactersNumber: Int = 0
    var isAnimatedOnce: Bool = false
    
    
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
        label.text = "Numéro de téléphone"
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
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        label.text = "SAISIR VOTRE NUMERO DE TÉLÉPHONE"
        // For multiple text colour
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "SAISIR VOTRE NOUVEAU NUMERO DE TÉLÉPHONE")
        attributedString.setColorForText(textForAttribute: "SAISIR VOTRE", withColor: .black)
        attributedString.setColorForText(textForAttribute: "NOUVEAU", withColor: .blueMerci)
        attributedString.setColorForText(textForAttribute: "NUMERO DE TÉLÉPHONE", withColor: .black)
        
        
        label.attributedText = attributedString
        
        return label
        
    }()

    let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "n° mobile"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.keyboardType = UIKeyboardType.numberPad
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.backgroundColor = .clear
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        return textField
    }()
    
    let dividerLineView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor.blueMerci
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.isHidden = true
        return divider
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ENVOYER", for: .normal)
        button.addTarget(self, action: #selector(handleSendPhoneNumber), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        button.isHidden = true
        return button
    }()

    @objc private func handleSendPhoneNumber(){
        print("try to send phone number")
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController!)
        
        
        guard let phoneNumber = phoneNumberTextField.text else { return  }
        let subPhoneNumber = phoneNumber.dropFirst()
        let stringPhoneNumber = String(subPhoneNumber)
        let validePhoneNumber = "+33" + stringPhoneNumber
        PhoneAuthProvider.provider().verifyPhoneNumber(validePhoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                self.alertController?.dismiss(animated: true, completion: nil)
                print("error: \(String(describing: error?.localizedDescription))")
            } else {
                let defaults = UserDefaults.standard
                defaults.set(verificationID, forKey: "authVID")
                self.alertController?.dismiss(animated: true, completion: {
                    let codePhoneNumberModifiedViewController = CodePhoneNumberModifiedViewController()
                    
                    codePhoneNumberModifiedViewController.phoneNumber = validePhoneNumber
                    DispatchQueue.main.async {
                        self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                        self.navigationController?.pushViewController(codePhoneNumberModifiedViewController, animated: false)
                    }
                })
            }
        }
    }
    
    
    let firstIndicationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 11)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.text = "Par mesure de sécurité,\n vous allez recevoir un code d'inscription par sms"
        return textView
    }()
    
    @objc private func textFieldDidChange(textField: UITextField){
        print("Text changed")
        let text = textField.text ?? ""
        // If the TextField is empty
        if text == ""{
            print("nothing")
            reSetupLine()
            sendButton.isHidden = true
            isAnimatedOnce = false
            return
        }
        
        let numberOfCharacters: Int = text.count
        
        
        // If the TextField recognize a phone number
        if(text.prefix(1) == "0"){
            print("write 0")
            if(numberOfCharacters > previousCharactersNumber){
                // On augmente d'un character
                if(numberOfCharacters % 2 == 0){
                    print("multiple de 2")
                    animateLine()
                    
                }
            } else {
                // On diminue d'un character
                if(numberOfCharacters % 2 == 1){
                    print("pas multiple de 2")
                    if(isAnimatedOnce){
                        desAnimateLine()
                    }
                }
                
                
            }
            
        } else {
            print("not a french phone number")
            
        }
        
        previousCharactersNumber = numberOfCharacters
    }
    let secondIndicationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 11)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.text = "Ce numéro permettra de sécuriser votre compte \n grâce à l'authentification à deux facteurs"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        phoneNumberTextField.delegate = self
        view.backgroundColor = .white
        setupViews()
        if profileImageUrl != "none"{
            self.displayProfileImage(imageUrl: profileImageUrl, imageView: profileImageView)
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupAnimatedLine()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    private func setupViews(){
        setupFormContainerView()
        setupBottomView()
        
    }
    
    private func setupFormContainerView(){
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        containerView.addSubview(phoneNumberLabel)
        containerView.addSubview(phoneNumberTextField)
        containerView.addSubview(dividerLineView)
        containerView.addSubview(sendButton)
        containerView.addSubview(firstIndicationTextView)
        
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
        
        self.addConstraintFromView(subview: containerView, attribute: .centerY, multiplier: 1.2, identifier: "formContainverView placement Y")
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: paddingTextField(positive: true)),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: paddingTextField(positive: false)),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
            ])
        NSLayoutConstraint.activate([
            phoneNumberLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            phoneNumberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            phoneNumberLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.18),
            ])
        NSLayoutConstraint.activate([
            phoneNumberTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            phoneNumberTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.21),
            ])
        NSLayoutConstraint.activate([
            dividerLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dividerLineView.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 10),
            dividerLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dividerLineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dividerLineView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.012)
            ])
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.14)
            ])
        NSLayoutConstraint.activate([
            firstIndicationTextView.trailingAnchor.constraint(equalToSystemSpacingAfter: containerView.trailingAnchor, multiplier: 0.10),
            firstIndicationTextView.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 0.10),
            firstIndicationTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            firstIndicationTextView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3)
            ])
        
    }
    
    private func setupBottomView(){
        containerView.addSubview(secondIndicationTextView)
        NSLayoutConstraint.activate([
            secondIndicationTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondIndicationTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            secondIndicationTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            secondIndicationTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            secondIndicationTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08)
            ])
        
    }
    
    private func setupAnimatedLine(){
        let linePath = UIBezierPath()
        // Start point
        linePath.move(to: CGPoint(x: 0, y: dividerLineView.center.y))
        // End point
        linePath.addLine(to: CGPoint(x: containerView.frame.width, y: dividerLineView.center.y))
        
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor.blueMerci.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        containerView.layer.addSublayer(shapeLayer)
    }
    
    private func animateLine(){
        isAnimatedOnce = true
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0 + offset
        basicAnimation.toValue = offset + 0.2
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        offset += 0.2
        if(offset == 1){
            sendButton.isHidden = false
        }
        shapeLayer.add(basicAnimation, forKey: "animate line left to the right")
    }
    
    private func desAnimateLine(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = offset
        basicAnimation.toValue = offset - 0.2
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        offset -= 0.2
        if(!sendButton.isHidden){
            sendButton.isHidden = true
        }
        shapeLayer.add(basicAnimation, forKey: "animate line right to the left")
    }
    
    private func reSetupLine(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = offset
        basicAnimation.toValue = 0.0
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        offset = 0.0
        if(!sendButton.isHidden){
            sendButton.isHidden = true
        }
        shapeLayer.add(basicAnimation, forKey: "animate line right to the left")
    }
}
