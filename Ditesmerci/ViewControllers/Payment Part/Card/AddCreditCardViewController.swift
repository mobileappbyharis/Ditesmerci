//
//  AddCreditCardViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 14/02/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions
import Alamofire

class AddCreditCardViewController : UIViewController, UITextFieldDelegate {
    var name = "none"
    var profileImageUrl = "none"
    
    //------Begin MangoPay Setup Variables------
    var cardRegistrationResponseModel: CardRegistrationResponseModel?
    let MPbaseUrl = "https://api.sandbox.mangopay.com"
    let MPclientID = "ditesmerci"
    let MPclientApiKey = "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU"
    let authorizationHeader = "Basic \(("ditesmerci" + ":" + "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU").data(using: .utf8)!.base64EncodedString())"
    //------End MangoPay Setup Variables------
    var listenerRegistration : ListenerRegistration?
    
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
    
    let enterDigitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Entrer les numéros"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .purpleMerci
        return label
    }()
    
    let dividerLineView: UIView = {
        let divider = UIView()
        divider.backgroundColor = .purpleMerci
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    let textfieldsView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    let creditCardDigitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "N° DE CARTE"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let creditCardDigitsTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "**** **** **** ****"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numberPad
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        return textField
    }()
    
    @objc func didChangeText(textField:UITextField) {
//        textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }
    
    let expiredDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DATE D'EXPIRATION"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    let expiredDateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "MM/AA"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    let cryptoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CRYPTO"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    let cryptoTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "000"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numberPad
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
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
    
    @objc private func handleSendCreditCardInfo() {
        print("trying to send credit card informations")
        sendButton.isEnabled = false
        if creditCardDigitsTextField.text?.count != 16 || expiredDateTextField.text!.isEmpty || cryptoTextField.text?.count != 3 {
            displayAlertErrorUI(title: "Erreur", message: "Remplissez correctement tous les champs s'il vous plaît.", answer: "OK")
            sendButton.isEnabled = true
            return
        }
        AddACreditCard()
    }
    
    
    private var datePicker: UIDatePickerCreditCard?
    lazy var functions = Functions.functions(region: "europe-west1")
    var auth = Auth.auth()
    var db = Firestore.firestore()
    var alertController: UIAlertController?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        
        nameLabel.text = name
        if profileImageUrl != "none" {
            displayProfileImage(imageUrl: profileImageUrl, imageView: profileImageView)
        }
        
        creditCardDigitsTextField.delegate = self
        cryptoTextField.delegate = self
        expiredDateTextField.delegate = self
        
        datePicker = UIDatePickerCreditCard()
        expiredDateTextField.inputView = datePicker
    
        setupViews()
        
        createSetupIntent()
    }
    
    
    private func createSetupIntent() {
        print("begin getReplyCardRegistrationMangoPay cloud function")
        functions.httpsCallable("getReplyCardRegistrationMangoPay").call { (result, error) in
            if let error = error as NSError? {
              if error.domain == FunctionsErrorDomain {
                let code = FunctionsErrorCode(rawValue: error.code)
                let message = error.localizedDescription
                let details = error.userInfo[FunctionsErrorDetailsKey]
                  print("code: \(String(describing: code))")
                  print("message: \(message)")
                  print("details: \(String(describing: details))")
              }
            }
            if let replyJson = (result?.data as? [String: Any])?["replyJson"] as? [String:Any] {
                print("replyJson : \(replyJson)")
                self.cardRegistrationResponseModel = CardRegistrationResponseModel(dictionary: replyJson)
                print("end getReplyCardRegistrationMangoPay cloud function")

            }
        }
    }
    
    func AddACreditCard() {
        guard let cardRegistrationReplyModel = self.cardRegistrationResponseModel, let accessKeyRef = cardRegistrationResponseModel?.accessKey, let data = cardRegistrationResponseModel?.preregistrationData, let cardRegistrationId = cardRegistrationResponseModel?.id, let cardRegistrationURL = URL(string: (cardRegistrationResponseModel?.cardRegistrationURL)!) else {return}
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController!)
        // Collect card details
        let cardNumber = String(creditCardDigitsTextField.text!)
        let realExpiredDate = String(expiredDateTextField.text!.prefix(2) + expiredDateTextField.text!.suffix(2))
        let cardCvx = String(cryptoTextField.text!)
        
        print("cardNumber: \(cardNumber)")
        print("realExpiredDate: \(realExpiredDate)")
        print("cardCvx: \(cardCvx)")
        
        let cardDetailsModel = CardDetailsModel(accessKeyRef: accessKeyRef, data: data, cardNumber: cardNumber, cardExpirationDate: realExpiredDate, cardCvx: cardCvx)
        
        sendCardDetailsAndRequestRegistrationDataKey(cardDetailsModel: cardDetailsModel, cardRegistrationURL: cardRegistrationURL, cardRegistrationId: cardRegistrationId, cardRegistrationReplyModel: cardRegistrationReplyModel)
            
    }
    
    func sendCardDetailsAndRequestRegistrationDataKey(cardDetailsModel: CardDetailsModel, cardRegistrationURL: URL, cardRegistrationId: String, cardRegistrationReplyModel: CardRegistrationResponseModel) {
        let requestHeaders: [String:String] = ["Authorization": authorizationHeader,
                                               "Content-Type": "application/x-www-form-urlencoded"]
        
        var requestBodyComponents = URLComponents()
        //TODO : Changer les informations bancaires en réelle variables qui fonctionnent
        requestBodyComponents.queryItems = [URLQueryItem(name: "accessKeyRef", value: cardDetailsModel.accessKeyRef),
                                            URLQueryItem(name: "data", value: cardDetailsModel.data),
                                            URLQueryItem(name: "cardNumber", value: cardDetailsModel.cardNumber),
                                            URLQueryItem(name: "cardExpirationDate", value: cardDetailsModel.cardExpirationDate),
                                            URLQueryItem(name: "cardCvx", value: cardDetailsModel.cardCvx)]
        
        var request = URLRequest(url: cardRegistrationURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error urlsession: \(error.localizedDescription)")
                self.errorHappened()
                return
            }
            
            guard let data = data else {return}
            guard let registrationData = String(data: data, encoding: .utf8) else {return}
            print(registrationData)
            cardRegistrationReplyModel.registrationData = registrationData
            
            
            
            guard let uid = self.auth.currentUser?.uid else {return}
            let dataFirestore = [
                "Id": cardRegistrationReplyModel.id ?? "nil",
                "Tag": cardRegistrationReplyModel.tag ?? "nil",
                "CreationDate": cardRegistrationReplyModel.creationDate ?? "nil",
                "UserId": cardRegistrationReplyModel.userID ?? "nil",
                "AccessKey": cardRegistrationReplyModel.accessKey ?? "nil",
                "PreregistrationData": cardRegistrationReplyModel.preregistrationData ?? "nil",
                "RegistrationData": cardRegistrationReplyModel.registrationData ?? "nil",
                "CardId": cardRegistrationReplyModel.cardID ?? "nil",
                "CardType": cardRegistrationReplyModel.cardType ?? "nil",
                "CardRegistrationURL": cardRegistrationReplyModel.cardRegistrationURL ?? "nil",
                "ResultCode": cardRegistrationReplyModel.resultCode ?? "nil",
                "ResultMessage": cardRegistrationReplyModel.resultMessage ?? "nil",
                "Currency": cardRegistrationReplyModel.currency ?? "nil",
                "Status": cardRegistrationReplyModel.status ?? "nil"
                ] as [String: Any]
            self.db.collection("mangopay_customers").document(uid).collection("tokens").document().setData(dataFirestore, merge: true) { (error) in
                    if let error = error {
                        print("error : \(error.localizedDescription)")
                        self.errorHappened()
                        return
                    }
                self.successHappened()
                
            }
        }.resume()
    }
    
    func errorHappened(){
        DispatchQueue.main.async {
            self.alertController?.dismiss(animated: true, completion: {
              self.displayAlertErrorUI(title: "Erreur", message: "Une erreur est survenue, vérifiez votre connection internet.", answer: "ok")
              self.sendButton.isEnabled = true
            })
        }
    }
    
    func successHappened(){
        DispatchQueue.main.async {
          self.alertController?.dismiss(animated: true, completion: {
            self.displayAlertErrorUI(title: "Carte ajoutée", message: "Votre carte bancaire a bien été ajoutée.", answer: "ok")
            self.sendButton.isEnabled = true
          })
        }
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        if(textField == creditCardDigitsTextField) {
            return newLength <= 19
        }
        if(textField == cryptoTextField) {
            return newLength <= 3
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == creditCardDigitsTextField){
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
        })
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == expiredDateTextField){
            if let month = datePicker?.month, let year = datePicker?.year {
                var monthStr = String(month)
                if month < 10 {
                    monthStr = "0" + monthStr
                }
                let yearStr = String(year)
                let realYear = yearStr.suffix(2)
                
                let displayDate = monthStr + "/" + realYear
                print(displayDate)
                expiredDateTextField.text = displayDate
            }
        }
        
        
        if(textField == creditCardDigitsTextField){
            if (textField.attributedText?.length != 19) {
                textField.layer.borderColor = UIColor.red.cgColor
            } else {
                textField.layer.borderColor = UIColor.black.cgColor
            }
            return
        }
        // Keyboard up
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
        })
        
        if(textField == cryptoTextField){
            if (textField.attributedText?.length != 3) {
                textField.layer.borderColor = UIColor.red.cgColor
            } else {
                textField.layer.borderColor = UIColor.black.cgColor
            }
        }
        
    }
        
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()

        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""

        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(titleLabel)
        view.addSubview(enterDigitsLabel)
        view.addSubview(textfieldsView)
        textfieldsView.addSubview(creditCardDigitsLabel)
        textfieldsView.addSubview(creditCardDigitsTextField)
        textfieldsView.addSubview(expiredDateLabel)
        textfieldsView.addSubview(expiredDateTextField)
        textfieldsView.addSubview(cryptoLabel)
        textfieldsView.addSubview(cryptoTextField)
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
            enterDigitsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterDigitsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            textfieldsView.topAnchor.constraint(equalTo: enterDigitsLabel.bottomAnchor, constant: 60),
            textfieldsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textfieldsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textfieldsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
        ])
        NSLayoutConstraint.activate([
            creditCardDigitsLabel.topAnchor.constraint(equalTo: textfieldsView.topAnchor),
            creditCardDigitsLabel.leadingAnchor.constraint(equalTo: textfieldsView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            creditCardDigitsTextField.centerYAnchor.constraint(equalTo: creditCardDigitsLabel.centerYAnchor),
            creditCardDigitsTextField.leadingAnchor.constraint(equalTo: creditCardDigitsLabel.trailingAnchor, constant: 25),
            creditCardDigitsTextField.trailingAnchor.constraint(equalTo: textfieldsView.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            expiredDateLabel.topAnchor.constraint(equalTo: creditCardDigitsLabel.bottomAnchor, constant: 30),
            expiredDateLabel.leadingAnchor.constraint(equalTo: textfieldsView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            expiredDateTextField.centerYAnchor.constraint(equalTo: expiredDateLabel.centerYAnchor),
            expiredDateTextField.leadingAnchor.constraint(equalTo: creditCardDigitsLabel.trailingAnchor, constant: 25),
        ])
        NSLayoutConstraint.activate([
            cryptoLabel.topAnchor.constraint(equalTo: expiredDateLabel.bottomAnchor, constant: 30),
            cryptoLabel.leadingAnchor.constraint(equalTo: textfieldsView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            cryptoTextField.centerYAnchor.constraint(equalTo: cryptoLabel.centerYAnchor),
            cryptoTextField.leadingAnchor.constraint(equalTo: creditCardDigitsLabel.trailingAnchor, constant: 25),
        ])
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: textfieldsView.bottomAnchor),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
}

