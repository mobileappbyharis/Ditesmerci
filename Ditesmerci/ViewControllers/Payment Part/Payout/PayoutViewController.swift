//
//  PayoutViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 10/03/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import KMPlaceholderTextView


class PayoutViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Virement bancaire"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  Somme disponible  \n€  "
        label.backgroundColor = .purpleMerci
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Somme à virer sur mon compte"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .purpleMerci
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
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
    
    let ratio = (UIScreen.main.bounds.width * 0.6)/UIScreen.main.bounds.height
    var firstNumber = true
    var enableValidateButton = false
    lazy var functions = Functions.functions(region: "europe-west1")
    var alertController: UIAlertController?
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var balance = 0
    var isKYCValidated = false
    let MPbaseUrl = "https://api.sandbox.mangopay.com"
    let MPclientID = "ditesmerci"
    let MPclientApiKey = "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU"
    let authorizationHeader = "Basic \(("ditesmerci" + ":" + "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU").data(using: .utf8)!.base64EncodedString())"

    
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
            if !firstNumber && numberOfChars < 4  {
                displayAmountTextView.text = displayAmountTextView.text + String(number)
            }
            break
        case "<":
            displayAmountTextView.text = String(displayAmountTextView.text.dropLast())
            break
        default:
            if numberOfChars < 4 {
                displayAmountTextView.text = displayAmountTextView.text + String(number)
            }
            break
        }
    }
    
    @objc private func handleValidateAmount() {
        guard let amountInt = Int(self.displayAmountTextView.text) else {return}
        print("amount: \(amountInt)")
        if self.enableValidateButton {
            if balance == 0 || amountInt == 0 {
                DispatchQueue.main.async {
                    self.alertController?.dismiss(animated: true, completion: {
                        self.displayAlertErrorUI(title: "Erreur", message:"Vous ne pouvez pas faire de virement avec une solde de 0€." , answer: "OK")
                        return
                    })
                }
            } else if amountInt > balance/100 {
                DispatchQueue.main.async {
                    self.alertController?.dismiss(animated: true, completion: {
                        self.displayAlertErrorUI(title: "Erreur", message:"Montant supérieur à la solde de votre compte." , answer: "OK")
                        return
                    })
                }
            } else if !isKYCValidated {
                print("KYC not validated")
                DispatchQueue.main.async {
                    self.alertController?.dismiss(animated: true, completion: {
                        self.displayAlertErrorUI(title: "Erreur", message:"Vous devez nous envoyer une pièce d'identité que nos équipes valideront avant de pouvoir effectuer un virement. Pour le faire, allez dans la rubrique 'Vérification d'identité.'" , answer: "OK")
                        return
                    })
                }
            } else {
                self.displayWaitSpinner(alertController: self.alertController!)
                guard let uid = auth.currentUser?.uid else {return}
                db.collection("mangopay_customers").document(uid).collection("bank_accounts").whereField("isDefault", isEqualTo: true).addSnapshotListener { (querySnapshot, error) in
                    if let error = error {
                        print("error : \(error.localizedDescription)")
                        self.errorHappened()
                        return
                    }
                    
                    guard let querySnapshot = querySnapshot else {return}
                    
                    if querySnapshot.isEmpty {
                        DispatchQueue.main.async {
                            self.alertController?.dismiss(animated: true, completion: {
                                self.displayAlertErrorUI(title: "Erreur", message:"Vous devez d'abord enregistré un compte bancaire par défaut. Pour le faire, allez dans la rubrique 'Mes comptes bancaires.'" , answer: "OK")
                                return
                            })
                        }
                    } else {
                    print("trying to validate amount")
                    self.enableValidateButton = false
                    guard let amount = Int(self.displayAmountTextView.text) else {return}
                    self.functions.httpsCallable("payoutMangoPay").call(["credited_uid" : uid, "amount": amount*100]) { (result, error) in
                        self.enableValidateButton = true
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
                            if status == "CREATED" {
                                self.successHappened()
                            } else {
                                self.errorHappened()
                            }
                        }
                    }
                }
                }
            }
        }
    }
    
    func getStatusKYCRequest() {
        print("trying getStatusKYC request")
        guard let uid = auth.currentUser?.uid else {return}
        
        db.collection("mangopay_customers").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            guard let document = documentSnapshot?.data() else {return}
            let customerMP = CustomerMP(dictionary: document)
            guard let documentKYCId = customerMP.documentKYC_id else {
                print("no ID")
                self.isKYCValidated = false
                return
            }
            
            let requestHeaders: [String:String] = ["Authorization": self.authorizationHeader,
                                                   "Content-Type": "application/json"]
            
            print("documentKYCId: \(documentKYCId)")
            guard let url = URL(string: "https://api.sandbox.mangopay.com/v2.01/\(self.MPclientID)/kyc/documents/\(documentKYCId)/") else {return}

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = requestHeaders
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("error urlsession: \(error.localizedDescription)")
                    self.errorHappened()
                    return
                }
                
                guard let data = data else {return}
                guard let replyJson = String(data: data, encoding: .utf8) else {return}
                print(replyJson)
                do {
                    let decoder = JSONDecoder()
                    //Decode JSON Response Data
                    let documentKYCMP = try decoder.decode(DocumentKYCMP.self, from: data)
                    print(documentKYCMP.Id ?? "null")
                    
                    
                    if documentKYCMP.Status == "VALIDATION_ASKED" {
                        print("KYC processing")
                        self.isKYCValidated = false
                    } else if documentKYCMP.Status == "VALIDATED" {
                        self.isKYCValidated = true
                    } else if documentKYCMP.Status == "REFUSED" {
                        print("KYC refused")
                        self.isKYCValidated = false
                    } else if documentKYCMP.Status == "OUT_OF_DATE" {
                        print("KYC OUT_OF_DATE")
                        self.isKYCValidated = false
                    } else {
                        print("KYC CREATED")
                        self.isKYCValidated = false
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                    self.errorHappened()
                }
            }
            task.resume()
            
        }
        
        
    }

    
    
    func errorHappened(){
        DispatchQueue.main.async {
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Erreur", message:"Une erreur est survenu lors du virement." , answer: "OK")
            })
        }
    }
    
    func successHappened(){
        DispatchQueue.main.async {
          self.alertController?.dismiss(animated: true, completion: {
              self.displayAlertErrorUI(title: "Succès", message: "Votre virement a bien été effectué. Vous recevrez votre montant d'ici quelques jours.", answer: "OK")
            self.getWalletBalanceRequest()
          })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        setupViews()
        getWalletBalanceRequest()
        getStatusKYCRequest()
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
                      self.totalLabel.text = "  Somme disponible  \n\(balance/100) €  "
                      self.enableValidateButton = true
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
        }
        
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(totalLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(divider)
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
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.bottomAnchor.constraint(equalTo: displayAmountTextView.topAnchor, constant: -10),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 5),
            divider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            divider.heightAnchor.constraint(equalToConstant: 2),
            divider.widthAnchor.constraint(equalTo: subtitleLabel.widthAnchor)
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
