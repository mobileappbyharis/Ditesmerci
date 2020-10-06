//
//  PourboireVC.swift
//  Ditesmerci
//
//  Created by 7k04 on 23/02/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import KMPlaceholderTextView


class PourboireVC: UIViewController, UITextViewDelegate {
    
    let merciWalletButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Compte\n Merci ", for: .normal)
        button.addTarget(self, action: #selector(handleMerciAccountSelection), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blueMerci
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blueMerci.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 50.0, bottom: 8.0, right: 50.0)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let creditCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Carte\n bancaire ", for: .normal)
        button.addTarget(self, action: #selector(handleCreditCardSelection), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.blueMerci, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blueMerci.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 50.0, bottom: 8.0, right: 50.0)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = .center

        return button
    }()
    
    let merciWalletTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 13)
        textView.textColor = .white
        textView.backgroundColor = .purpleMerci
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.text = "€"
        textView.isHidden = false
        return textView
    }()
    
    let creditCardTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 13)
        textView.textColor = .white
        textView.backgroundColor = .purpleMerci
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isHidden = true
        textView.text = "xxxx "
        return textView
    }()
    
    let displayAmountTextView: KMPlaceholderTextView = {
        let textView = KMPlaceholderTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 60)
        textView.textColor = .black
        textView.placeholder = "1€"
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.centerVertically()
        return textView
    }()
    
    let numbersView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let numberOneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("1", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let numberTwoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let numberThreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("3", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let numberFourButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("4", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let numberFiveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("5", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let numberSixButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("6", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let numberSevenButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("7", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let numberEightButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("8", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let numberNineButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("9", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let eraseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("<", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let numberZeroButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("0", for: .normal)
        button.addTarget(self, action: #selector(handleNumberDisplay), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    lazy var validateImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "validate")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleValidateAmount)))
        return imageView
    }()
    
    lazy var functions = Functions.functions(region: "europe-west1")
    var db = Firestore.firestore()
    var defaultPaymentMethodId: String?
    
    var isWallet = true // false = credit card ; true = wallet
    let ratio = (UIScreen.main.bounds.width * 0.6)/UIScreen.main.bounds.height
    var firstNumber = true
    var enableValidateButton = true
    var employeeUid: String?
    var isDefaultCard = false
    var balance = 0
    var alertController: UIAlertController?
    let MPbaseUrl = "https://api.sandbox.mangopay.com"
    let MPclientID = "ditesmerci"
    let MPclientApiKey = "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU"
    let authorizationHeader = "Basic \(("ditesmerci" + ":" + "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU").data(using: .utf8)!.base64EncodedString())"
    
    
    @objc private func handleMerciAccountSelection() {
        print("trying to select merci account")
        
        merciWalletButton.backgroundColor = .blueMerci
        merciWalletButton.setTitleColor(.white, for: .normal)
        merciWalletTextView.isHidden = false
        
        creditCardButton.backgroundColor = .white
        creditCardButton.setTitleColor(.blueMerci, for: .normal)
        creditCardTextView.isHidden = true
        
        isWallet = true

    }
    @objc private func handleCreditCardSelection() {
        print("trying to select credit card")
        
        if !isDefaultCard {
            displayAlertErrorUI(title: "Carte par défaut non définit", message: "Aller dans la rubrique 'Cartes Bancaires' sur votre profil pour définir une carte par défaut.", answer: "OK")
        } else {
            merciWalletButton.backgroundColor = .white
            merciWalletButton.setTitleColor(.blueMerci, for: .normal)
            merciWalletTextView.isHidden = true
            
            creditCardButton.backgroundColor = .blueMerci
            creditCardButton.setTitleColor(.white, for: .normal)
            creditCardTextView.isHidden = false
            
            isWallet = false
        }
    }
    
    @objc private func handleNumberDisplay(sender:UIButton) {
        print("trying to display number")
        guard let buttonTaped = sender.titleLabel!.text else {return}
        let number = Character(buttonTaped)
        let numberOfChars = displayAmountTextView.text.count
        if numberOfChars == 0 {
            firstNumber = true
        } else {
            firstNumber = false
        }
        
        switch number {
        case "0":
            if !firstNumber && numberOfChars < 3  {
                displayAmountTextView.text = displayAmountTextView.text + String(number)
            }
            break
        case "<":
            displayAmountTextView.text = String(displayAmountTextView.text.dropLast())
            break
        default:
            if numberOfChars < 3 {
                displayAmountTextView.text = displayAmountTextView.text + String(number)
            }
            break
        }
    }

    @objc private func handleValidateAmount() {
        print("trying to validate amount")
        if enableValidateButton {
            enableValidateButton = false
            if isWallet {
                guard let amount = Int(displayAmountTextView.text) else {return}
                if balance == 0 {
                    DispatchQueue.main.async {
                        self.enableValidateButton = true
                        self.alertController?.dismiss(animated: true, completion: {
                            self.displayAlertErrorUI(title: "Erreur", message:"Votre solde est égale à 0€." , answer: "OK")
                        })
                    }
                } else if amount > balance {
                    DispatchQueue.main.async {
                        self.enableValidateButton = true
                        self.alertController?.dismiss(animated: true, completion: {
                            self.displayAlertErrorUI(title: "Erreur", message:"Vous ne pouvez pas faire de virement avec 0€." , answer: "OK")
                        })
                    }
                } else if amount == 0 {
                    DispatchQueue.main.async {
                        self.enableValidateButton = true
                        self.alertController?.dismiss(animated: true, completion: {
                            self.displayAlertErrorUI(title: "Erreur", message:"Vous ne pouvez pas faire de don à 0€." , answer: "OK")
                        })
                    }
                } else {
                    processTransfer()
                }
            } else {
                processPayIn()
            }
            
        }
    }
    
    
    private func getWalletBalanceRequest() {
        let requestHeaders: [String:String] = ["Authorization": self.authorizationHeader,
                                               "Content-Type": "application/json"]

        guard let uid = Auth.auth().currentUser?.uid else {return}
        db.collection("mangopay_customers").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            guard let document = documentSnapshot?.data() else {return}
            let user = CustomerMP(dictionary: document)
            guard let wallet_id = user.wallet_id else {return}
            print("wallet_id: \(wallet_id)")
            guard let url = URL(string: "https://api.sandbox.mangopay.com/v2.01/\(self.MPclientID)/wallets/\(wallet_id)/") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = requestHeaders
            
            let task = URLSession.shared.dataTask(with: request)  { (data, response, error) in
                if let error = error {
                    print("error urlsession: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    return
                }
                guard let replyJson = String(data: data, encoding: .utf8) else {return}
                print(replyJson)
                
                do {
                    let decoder = JSONDecoder()
                    //Decode JSON Response Data
                    let walletMP = try decoder.decode(WalletMP.self, from: data)
                    let balance = walletMP.balance.amount
                    print(balance)
                    self.balance = balance
                    DispatchQueue.main.async {
                      self.merciWalletTextView.text = "\(balance/100) €"
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
        }
        
    }
    
    // PayIn is payment with the defaultCard
    private func processPayIn() {
        self.displayWaitSpinner(alertController: alertController!)
        guard let fakeAmount = Int(displayAmountTextView.text) else {return}
        print("fakeAmount : \(fakeAmount)")
        let amount = fakeAmount * 100
        print("amount : \(amount)")
        guard let creditedUid = self.employeeUid else {return}
        functions.httpsCallable("payInMangoPay").call(["amount": amount, "credited_uid": creditedUid]) { (result, error) in
            if let error = error as NSError? {
              if error.domain == FunctionsErrorDomain {
                let code = FunctionsErrorCode(rawValue: error.code)
                let message = error.localizedDescription
                let details = error.userInfo[FunctionsErrorDetailsKey]
                  print("code: \(String(describing: code))")
                  print("message: \(message)")
                  print("details: \(String(describing: details))")
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Erreur", message:"Une erreur est survenu lors du paiement. Vous n'avez pas été débité." , answer: "OK")
                })
                self.enableValidateButton = true
              }
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Erreur", message:"Une erreur est survenu lors du paiement. Vous n'avez pas été débité." , answer: "OK")
                })
                self.enableValidateButton = true
            }
            if let status = (result?.data as? [String: Any])?["status"] as? String {
              print("status : \(status)")
                if status == "FAILED" {
                    print("error PayIn")
                    self.alertController?.dismiss(animated: true, completion: {
                        self.displayAlertErrorUI(title: "Erreur", message:"Une erreur est survenu lors du paiement. Vous n'avez pas été débité." , answer: "OK")
                    })
                    return
                }
                self.enableValidateButton = true
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Succès", message: "Votre pourboire a bien été envoyé", answer: "OK")
                    self.getWalletBalanceRequest()
                })
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    // Transfer is payment with Wallet
    private func processTransfer() {
        self.displayWaitSpinner(alertController: alertController!)
        guard let amount = Int(displayAmountTextView.text), let creditedUid = self.employeeUid else {return}
        functions.httpsCallable("transferMangoPay").call(["amount": amount*100, "credited_uid": creditedUid]) { (result, error) in
            if let error = error as NSError? {
              if error.domain == FunctionsErrorDomain {
                let code = FunctionsErrorCode(rawValue: error.code)
                let message = error.localizedDescription
                let details = error.userInfo[FunctionsErrorDetailsKey]
                  print("code: \(String(describing: code))")
                  print("message: \(message)")
                  print("details: \(String(describing: details))")
                self.enableValidateButton = true
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Erreur", message:"Une erreur est survenu lors du paiement. Vous n'avez pas été débité." , answer: "OK")
                })
              }
                self.enableValidateButton = true
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Erreur", message:"Une erreur est survenu lors du paiement. Vous n'avez pas été débité." , answer: "OK")
                })
            }
            if let status = (result?.data as? [String: Any])?["status"] as? String {
              print("status : \(status)")
                if status == "FAILED" {
                    print("error transfer")
                    self.enableValidateButton = true
                    self.alertController?.dismiss(animated: true, completion: {
                        self.displayAlertErrorUI(title: "Erreur", message:"Une erreur est survenu lors du paiement. Vous n'avez pas été débité." , answer: "OK")
                    })
                    return
                }
                self.enableValidateButton = true
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Succès", message: "Votre pourboire a bien été envoyé", answer: "OK")
                    self.getWalletBalanceRequest()
                })
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.hideKeyboardWhenTappedAround()
        displayAmountTextView.delegate = self
        retrieveDefaultCard()
        getWalletBalanceRequest()
        setupViews()
    }
    
    
    
    private func retrieveDefaultCard(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        db.collection("mangopay_customers").document(uid).collection("cards").whereField("isDefault", isEqualTo: true).getDocuments { (querySnapshots, error) in
            if let error = error {
                print("error \(error.localizedDescription)")
                return
            }
            guard let querySnapshots = querySnapshots else {return}
            if querySnapshots.isEmpty {
                self.isDefaultCard = false
                return
            }
            self.isDefaultCard = true
            let document = querySnapshots.documents[0]

            let defaultCard = CardModel(dictionary: document.data())
            guard let last4 = defaultCard.alias?.suffix(4) else {return}
            self.creditCardTextView.text = "xxxx " + last4
            self.enableValidateButton = true
        }
    }
    
    
    private func setupViews() {
        view.addSubview(merciWalletButton)
        view.addSubview(creditCardButton)
        view.addSubview(merciWalletTextView)
        view.addSubview(creditCardTextView)
        view.addSubview(numbersView)
        view.addSubview(displayAmountTextView)
        numbersView.addSubview(numberOneButton)
        numbersView.addSubview(numberTwoButton)
        numbersView.addSubview(numberThreeButton)
        numbersView.addSubview(numberFourButton)
        numbersView.addSubview(numberFiveButton)
        numbersView.addSubview(numberSixButton)
        numbersView.addSubview(numberSevenButton)
        numbersView.addSubview(numberEightButton)
        numbersView.addSubview(numberNineButton)
        numbersView.addSubview(eraseButton)
        numbersView.addSubview(numberZeroButton)
        numbersView.addSubview(validateImageView)




        let constraintMerciWalletButton = NSLayoutConstraint(item: merciWalletButton,
                                                          attribute: .centerX,
                                                          relatedBy: .equal,
                                                          toItem: view,
                                                          attribute: .centerX,
                                                          multiplier: 0.5,
                                                          constant: 0)
        constraintMerciWalletButton.identifier = "merciWalletButton placement X"
        view.addConstraint(constraintMerciWalletButton)
        
        NSLayoutConstraint.activate([
            merciWalletButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
        
        let constraintCreditCardButton = NSLayoutConstraint(item: creditCardButton,
                                                          attribute: .centerX,
                                                          relatedBy: .equal,
                                                          toItem: view,
                                                          attribute: .centerX,
                                                          multiplier: 1.5,
                                                          constant: 0)
        constraintCreditCardButton.identifier = "creditCardButton placement X"
        view.addConstraint(constraintCreditCardButton)
        
        NSLayoutConstraint.activate([
            creditCardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
        NSLayoutConstraint.activate([
            merciWalletTextView.topAnchor.constraint(equalTo: merciWalletButton.bottomAnchor),
            merciWalletTextView.centerXAnchor.constraint(equalTo: merciWalletButton.centerXAnchor),
            merciWalletTextView.widthAnchor.constraint(equalTo: merciWalletButton.widthAnchor, multiplier: 0.8),

        ])
        NSLayoutConstraint.activate([
            creditCardTextView.topAnchor.constraint(equalTo: creditCardButton.bottomAnchor),
            creditCardTextView.centerXAnchor.constraint(equalTo: creditCardButton.centerXAnchor),
            creditCardTextView.widthAnchor.constraint(equalTo: creditCardButton.widthAnchor, multiplier: 0.8),

        ])
        
        let constraintNumbersView = NSLayoutConstraint(item: numbersView,
                                                          attribute: .centerY,
                                                          relatedBy: .equal,
                                                          toItem: view,
                                                          attribute: .centerY,
                                                          multiplier: 1.2,
                                                          constant: 0)
        constraintNumbersView.identifier = "numbersView placement Y"
        view.addConstraint(constraintNumbersView)
        
        NSLayoutConstraint.activate([
            numbersView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numbersView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: ratio),
            numbersView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
        ])
        NSLayoutConstraint.activate([
            displayAmountTextView.bottomAnchor.constraint(equalTo: numbersView.topAnchor),
            displayAmountTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayAmountTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            displayAmountTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),

        ])
        NSLayoutConstraint.activate([
            numberOneButton.topAnchor.constraint(equalTo: numbersView.topAnchor),
            numberOneButton.leftAnchor.constraint(equalTo: numbersView.leftAnchor),
            numberOneButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberOneButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        NSLayoutConstraint.activate([
            numberTwoButton.topAnchor.constraint(equalTo: numbersView.topAnchor),
            numberTwoButton.centerXAnchor.constraint(equalTo: numbersView.centerXAnchor),
            numberTwoButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberTwoButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        NSLayoutConstraint.activate([
            numberThreeButton.topAnchor.constraint(equalTo: numbersView.topAnchor),
            numberThreeButton.rightAnchor.constraint(equalTo: numbersView.rightAnchor),
            numberThreeButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberThreeButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
        NSLayoutConstraint.activate([
            numberFourButton.topAnchor.constraint(equalTo: numberOneButton.bottomAnchor),
            numberFourButton.leftAnchor.constraint(equalTo: numbersView.leftAnchor),
            numberFourButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberFourButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
        NSLayoutConstraint.activate([
            numberFiveButton.topAnchor.constraint(equalTo: numberTwoButton.bottomAnchor),
            numberFiveButton.centerXAnchor.constraint(equalTo: numbersView.centerXAnchor),
            numberFiveButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberFiveButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
        NSLayoutConstraint.activate([
            numberSixButton.topAnchor.constraint(equalTo: numberThreeButton.bottomAnchor),
            numberSixButton.rightAnchor.constraint(equalTo: numbersView.rightAnchor),
            numberSixButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberSixButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
        NSLayoutConstraint.activate([
            numberSevenButton.topAnchor.constraint(equalTo: numberFourButton.bottomAnchor),
            numberSevenButton.leftAnchor.constraint(equalTo: numbersView.leftAnchor),
            numberSevenButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberSevenButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
        NSLayoutConstraint.activate([
            numberEightButton.topAnchor.constraint(equalTo: numberFiveButton.bottomAnchor),
            numberEightButton.centerXAnchor.constraint(equalTo: numbersView.centerXAnchor),
            numberEightButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberEightButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
        NSLayoutConstraint.activate([
            numberNineButton.topAnchor.constraint(equalTo: numberSixButton.bottomAnchor),
            numberNineButton.rightAnchor.constraint(equalTo: numbersView.rightAnchor),
            numberNineButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberNineButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
        NSLayoutConstraint.activate([
            eraseButton.topAnchor.constraint(equalTo: numberSevenButton.bottomAnchor),
            eraseButton.leftAnchor.constraint(equalTo: numbersView.leftAnchor),
            eraseButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            eraseButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
        NSLayoutConstraint.activate([
            numberZeroButton.topAnchor.constraint(equalTo: numberEightButton.bottomAnchor),
            numberZeroButton.centerXAnchor.constraint(equalTo: numbersView.centerXAnchor),
            numberZeroButton.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/3),
            numberZeroButton.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
        NSLayoutConstraint.activate([
            validateImageView.topAnchor.constraint(equalTo: numberNineButton.bottomAnchor),
            validateImageView.centerXAnchor.constraint(equalTo: numberNineButton.centerXAnchor),
            validateImageView.widthAnchor.constraint(equalTo: numbersView.widthAnchor, multiplier: 1/4),
            validateImageView.heightAnchor.constraint(equalTo: numbersView.heightAnchor, multiplier: 1/4),

        ])
        
    }
    
    
}
