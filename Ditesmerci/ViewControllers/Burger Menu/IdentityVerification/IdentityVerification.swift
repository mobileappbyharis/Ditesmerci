//
//  Verification.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 19/07/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import AssetsLibrary
class IdentityVerification: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vérification d'identité"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let idCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Ajouter une carte d'identité  ", for: .normal)
        button.addTarget(self, action: #selector(handleAddIdCard), for: .touchUpInside)
        button.backgroundColor = .blueMerci
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let passportButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Ajouter un passeport  ", for: .normal)
        button.addTarget(self, action: #selector(handleAddPassport), for: .touchUpInside)
        button.backgroundColor = .blueMerci
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var profileImageUrl = "none"
    var firstName = "none"
    var lastName = "none"
    var profileViewController: ProfileViewController?
    //lazy var functions = Functions.functions(region: "europe-west1")
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var storage = Storage.storage()
    var alertController: UIAlertController?
    var isPassport = true
    var is2images = false
    var pngImage: Data?
    var pngImage2: Data?
    var urlPath: String?
    var urlPath2: String?
    var isDocumentKYC = true
    
    let MPbaseUrl = "https://api.sandbox.mangopay.com"
    let MPclientID = "ditesmerci"
    let MPclientApiKey = "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU"
    let authorizationHeader = "Basic \(("ditesmerci" + ":" + "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU").data(using: .utf8)!.base64EncodedString())"
    
    private let vc: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.mediaTypes = ["public.image"]
        return vc
    }()
    
    @objc private func handleAddIdCard(){
        print("trying to add id card")
        isPassport = false
        is2images = false
        
        present(vc, animated: true)
    }
    
    @objc private func handleAddPassport(){
        print("trying to add passport")
        isPassport = true
        is2images = false
        present(vc, animated: true)
    }
    
    
    //    func submitPassport(file: String) {
    //        print("try to submit passport")
    //        functions.httpsCallable("submitPassportKYCMangoPay").call(["file": file]) { (result, error) in
    //            if let error = error as NSError? {
    //              if error.domain == FunctionsErrorDomain {
    //                let code = FunctionsErrorCode(rawValue: error.code)
    //                let message = error.localizedDescription
    //                let details = error.userInfo[FunctionsErrorDetailsKey]
    //                  print("code: \(String(describing: code))")
    //                  print("message: \(message)")
    //                  print("details: \(String(describing: details))")
    //                self.errorHappened()
    //              }
    //                self.errorHappened()
    //            }
    //            if let status = (result?.data as? [String: Any])?["status"] as? String {
    //              print("status : \(status)")
    //                if status == "VERIFICATION_ASKED" {
    //                    print("passport: status is VERIFICATION_ASKED")
    //                    self.deletePassport()
    //                    self.successHappened()
    //                } else {
    //                    self.errorHappened()
    //                }
    //
    //            }
    //        }
    //    }
    //
    //    func submitCardId(file: String, file2: String){
    //        print("try to submit cardId")
    //        functions.httpsCallable("submitCardIDKYCMangoPay").call(["file": file, "file2": file2]) { (result, error) in
    //            if let error = error as NSError? {
    //              if error.domain == FunctionsErrorDomain {
    //                let code = FunctionsErrorCode(rawValue: error.code)
    //                let message = error.localizedDescription
    //                let details = error.userInfo[FunctionsErrorDetailsKey]
    //                  print("code: \(String(describing: code))")
    //                  print("message: \(message)")
    //                  print("details: \(String(describing: details))")
    //                self.errorHappened()
    //              }
    //                self.errorHappened()
    //            }
    //            if let status = (result?.data as? [String: Any])?["status"] as? String {
    //              print("status : \(status)")
    //                if status == "VERIFICATION_ASKED" {
    //                    print("cardId: status is VERIFICATION_ASKED")
    //                    self.deleteCardId()
    //                    self.successHappened()
    //                } else {
    //                    self.errorHappened()
    //                }
    //
    //            }
    //        }
    //    }
    
    func successHappened(){
        DispatchQueue.main.async(execute: {
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Succès", message:"Votre pièce d'identité a bien été envoyée. Nous vous tiendrons informé une fois qu'elle sera validée par nos équipes." , answer: "OK")
            })
            })
    }
    
    func errorHappened(){
        DispatchQueue.main.async(execute: {
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Erreur", message:"Une erreur est survenue. Réessayez plus tard." , answer: "OK")
            })
            })
    }
    
    func displaySpinner(){
        self.displayWaitSpinner(alertController: alertController!)
    }
    
    
    //    func uploadPassport(pngImage: Data){
    //        print("try to upload passport")
    //        guard let uid = auth.currentUser?.uid else {return}
    //        let passportRef = storage.reference().child("images").child("users").child(uid).child("identity").child("passport.png")
    //        // Upload the file to the path "images/rivers.jpg"
    //        displaySpinner()
    //        passportRef.putData(pngImage, metadata: nil) { (metadata, error) in
    //            if let error = error {
    //                print("error: \(error.localizedDescription)")
    //                self.errorHappened()
    //                return
    //            }
    //            guard let metadata = metadata else {return}
    //            print("size: \(metadata.size)")
    //            passportRef.downloadURL { (url, error) in
    //                if let error = error {
    //                    print("error: \(error.localizedDescription)")
    //                    self.errorHappened()
    //                    return
    //                }
    //                guard let passportURL = url else {return}
    //                self.submitPassport(file: passportURL.absoluteString)
    //            }
    //        }
    //    }
    //
    //    func uploadCardId(pngImage1: Data, pngImage2: Data){
    //        print("try to upload cardId")
    //        guard let uid = auth.currentUser?.uid else {return}
    //        let cardIdRef1 = storage.reference().child("images").child("users").child(uid).child("identity").child("cardIdRecto.png")
    //        let cardIdRef2 = storage.reference().child("images").child("users").child(uid).child("identity").child("cardIdVerso.png")
    //        displaySpinner()
    //        cardIdRef1.putData(pngImage1, metadata: nil) { (metadata, error) in
    //            if let error = error {
    //                print("error: \(error.localizedDescription)")
    //                self.errorHappened()
    //                return
    //            }
    //            guard let metadata = metadata else {return}
    //            print("size: \(metadata.size)")
    //            cardIdRef1.downloadURL { (url, error) in
    //                if let error = error {
    //                    print("error: \(error.localizedDescription)")
    //                    self.errorHappened()
    //                    return
    //                }
    //                guard let cardIdURL1 = url else {return}
    //                cardIdRef2.putData(pngImage2, metadata: nil) { (metadata2, error) in
    //                    if let error = error {
    //                        print("error: \(error.localizedDescription)")
    //                        self.errorHappened()
    //                        return
    //                    }
    //                    guard let metadata2 = metadata2 else {return}
    //                    print("size: \(metadata2.size)")
    //                    cardIdRef2.downloadURL { (url, error) in
    //                        if let error = error {
    //                            print("error: \(error.localizedDescription)")
    //                            self.errorHappened()
    //                            return
    //                        }
    //                        guard let cardIdURL2 = url else {return}
    //                        self.submitCardId(file: cardIdURL1.absoluteString, file2: cardIdURL2.absoluteString)
    //                    }
    //                }
    //
    //            }
    //        }
    //    }
    //
    //    func deletePassport() {
    //        guard let uid = auth.currentUser?.uid else {return}
    //        let passportRef = storage.reference().child("images").child("users").child(uid).child("identity").child("passport.png")
    //        passportRef.delete { error in
    //          if let error = error {
    //            // Uh-oh, an error occurred!
    //            print("error \(error.localizedDescription)")
    //          } else {
    //            // File deleted successfully
    //            print("success to delete passport in storage")
    //
    //          }
    //        }
    //    }
    //    func deleteCardId() {
    //        guard let uid = auth.currentUser?.uid else {return}
    //        let cardIdRef1 = storage.reference().child("images").child("users").child(uid).child("identity").child("cardIdRecto.png")
    //        let cardIdRef2 = storage.reference().child("images").child("users").child(uid).child("identity").child("cardIdVerso.png")
    //        cardIdRef1.delete { error in
    //          if let error = error {
    //            // Uh-oh, an error occurred!
    //            print("error \(error.localizedDescription)")
    //          } else {
    //            // File deleted successfully
    //            cardIdRef2.delete { error in
    //              if let error = error {
    //                // Uh-oh, an error occurred!
    //                print("error \(error.localizedDescription)")
    //              } else {
    //                // File deleted successfully
    //                print("success to delete cardIdRecto & cardIdVerso in storage")
    //              }
    //            }
    //          }
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        vc.delegate = self
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        setupViews()
        getStatusKYCRequest()
    }
    
    
    func setupUIKYCValidated() {
        DispatchQueue.main.async(execute: {
            self.passportButton.isEnabled = false
            self.idCardButton.isEnabled = false
            self.detailLabel.text = "Votre pièce d'identité a été validée. Vous pouvez à présent effectuer des virements depuis votre compte DitesMerci à votre compte principal."
        })
    }
    
    func setupUIKYCProcessing() {
        DispatchQueue.main.async(execute: {
            self.passportButton.isEnabled = false
            self.idCardButton.isEnabled = false
            self.detailLabel.text = "Votre pièce d'identité est en cours de validation."
            })
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
                self.isDocumentKYC = false
                return
            }
            self.isDocumentKYC = true
            
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
                        self.setupUIKYCProcessing()
                    } else if documentKYCMP.Status == "VALIDATED" {
                        print("KYC validated")
                        self.setupUIKYCValidated()
                    } else if documentKYCMP.Status == "REFUSED" {
                        print("KYC refused")
                    } else if documentKYCMP.Status == "OUT_OF_DATE" {
                        print("KYC OUT_OF_DATE")
                    } else {
                        print("KYC CREATED")
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                    self.errorHappened()
                }
            }
            task.resume()
            
        }
        
        
    }
    
    
    func createDocumentKYCRequest() {
        print("trying to createDocumentKYC")
        displaySpinner()
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("mangopay_customers").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("error \(error.localizedDescription)")
                self.errorHappened()
                return
            }
            
            guard let document = documentSnapshot?.data() else {
                self.errorHappened()
                return
            }
            
            let customerMP = CustomerMP(dictionary: document)
            guard let mango_id = customerMP.mango_id else {
                self.errorHappened()
                return
                
            }
            
            let requestHeaders: [String:String] = ["Authorization": self.authorizationHeader,
                                                   "Content-Type": "application/json"]
            
            print("mango_id: \(mango_id)")

            guard let url = URL(string: "https://api.sandbox.mangopay.com/v2.01/\(self.MPclientID)/users/\(mango_id)/kyc/documents/") else {
                self.errorHappened()
                return
            }
            
            let parameters: [String: Any] = ["Type" : "IDENTITY_PROOF", "Tag": "Salut"]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = requestHeaders
            request.httpBody = httpBody
            
            let task = URLSession.shared.dataTask(with: request)  { (data, response, error) in
                 if let error = error {
                                   print("error urlsession: \(error.localizedDescription)")
                                   self.errorHappened()
                                   return
                               }
                               
                               guard let data = data else {
                                   self.errorHappened()
                                   return
                               }
                               guard let replyJson = String(data: data, encoding: .utf8) else {return}
                               print(replyJson)
                               
                               do {
                                   let decoder = JSONDecoder()
                                   //Decode JSON Response Data
                                   let documentKYCMP = try decoder.decode(DocumentKYCMP.self, from: data)
                                print(documentKYCMP.Id ?? "null")
                                   if self.isPassport {
                                    self.createPassportPageKYCRequest(documentKYCId: documentKYCMP.Id!, mango_id: mango_id)
                                   } else {
                                    self.createCardIdKYCRequest(documentKYCId: documentKYCMP.Id!, mango_id: mango_id)
                                   }
                               } catch let parsingError {
                                   print("Error", parsingError)
                                   self.errorHappened()
                               }
            }
            task.resume()
            
        }
    }
    
    func createPassportPageKYCRequest(documentKYCId: String, mango_id: String) {
        print("trying passport request")
        let requestHeaders: [String:String] = ["Authorization": self.authorizationHeader,
                                               "Content-Type": "application/json"]
        
        
        guard let url = URL(string: "https://api.sandbox.mangopay.com/v2.01/\(self.MPclientID)/users/\(mango_id)/kyc/documents/\(documentKYCId)/pages") else {return}

        let parameters: [String: Any] = ["File" : urlPath!]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        //body parameters
        // request parameters
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error urlsession: \(error.localizedDescription)")
                self.errorHappened()
                return
            }
            
            guard let data = data else {return}
            guard let replyJson = String(data: data, encoding: .utf8) else {return}
            print(replyJson)
            self.updateKYCDocumentRequest(documentKYCId: documentKYCId, mango_id: mango_id)
        }
        task.resume()
    }
    
    func createCardIdKYCRequest(documentKYCId: String, mango_id: String) {
        print("trying cardId request")
        let requestHeaders: [String:String] = ["Authorization": self.authorizationHeader,
                                               "Content-Type": "application/json"]
        
        
        guard let url = URL(string: "https://api.sandbox.mangopay.com/v2.01/\(self.MPclientID)/users/\(mango_id)/kyc/documents/\(documentKYCId)/pages") else {return}
//        var requestBodyComponents = URLComponents()
//        //TODO : Changer les informations bancaires en réelle variables qui fonctionnent
//        requestBodyComponents.queryItems = [URLQueryItem(name: "File", value: file.absoluteString)

        let parameters: [String: Any] = ["File" : self.urlPath!]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        //body parameters
        // request parameters
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error urlsession: \(error.localizedDescription)")
                self.errorHappened()
                return
            }
            
            guard let data = data else {return}
            guard let replyJson = String(data: data, encoding: .utf8) else {return}
            print(replyJson)
            if self.isPassport {
                self.updateKYCDocumentRequest(documentKYCId: documentKYCId, mango_id: mango_id)
            } else {
//                var requestBodyComponents = URLComponents()
//                requestBodyComponents.queryItems = [URLQueryItem(name: "File", value: file2.absoluteString)]
                let parameters2: [String: Any] = ["File" : self.urlPath2!]
                guard let httpBody2 = try? JSONSerialization.data(withJSONObject: parameters2, options: []) else {
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = requestHeaders
                request.httpBody = httpBody2
                
               let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("error urlsession: \(error.localizedDescription)")
                        self.errorHappened()
                        return
                    }
                    guard let data = data else {return}
                    guard let replyJson = String(data: data, encoding: .utf8) else {return}
                    print(replyJson)
                    self.updateKYCDocumentRequest(documentKYCId: documentKYCId, mango_id: mango_id)
                }
                task.resume()
            }
        }
        task.resume()
    }
    
    func updateKYCDocumentRequest(documentKYCId: String, mango_id: String) {
        print("trying update request")
        let requestHeaders: [String:String] = ["Authorization": self.authorizationHeader,
                                               "Content-Type": "application/json"]
        
        
        guard let url = URL(string: "https://api.sandbox.mangopay.com/v2.01/\(self.MPclientID)/users/\(mango_id)/kyc/documents/\(documentKYCId)") else {return}
//        var requestBodyComponents = URLComponents()
//        requestBodyComponents.queryItems = [URLQueryItem(name: "Status", value: "VALIDATION_ASKED"),
//                                            URLQueryItem(name: "Tag", value: "custom meta")]
        let parameters: [String: Any] = ["Status" : "VALIDATION_ASKED", "Tag": "salut"]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = httpBody
        
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
                    guard let uid = self.auth.currentUser?.uid else {return}
                    self.db.collection("mangopay_customers").document(uid).setData(["documentKYC_id": documentKYCMP.Id!], merge: true) { (error) in
                        if let error = error {
                            print("error: \(error.localizedDescription)")
                        }
                        self.successHappened()
                        self.setupUIKYCProcessing()
                        print("success to store documentKYC in Firestore")
                    }
                } else {
                    self.errorHappened()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
                self.errorHappened()
            }
        }
        task.resume()
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("isPassport: \(isPassport)")
        print("is2images: \(is2images)")
        picker.dismiss(animated: true) {
            guard let image = info[.editedImage] as? UIImage else {
                print("No image found")
                return
            }
            
            
            let file64 = image.pngData()?.base64EncodedString()
            
            if self.is2images {
                self.urlPath2 = file64
            } else {
                self.urlPath = file64
            }
            
              
              
            print("size: \(image.size)")
            if self.isPassport {
                self.createDocumentKYCRequest()
            } else {
                if !self.is2images {
                    self.is2images = true
                    self.present(self.vc, animated: true)
                } else {
                    self.createDocumentKYCRequest()
                }
            }
            
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(idCardButton)
        view.addSubview(passportButton)
        view.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            idCardButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            idCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            idCardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            idCardButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
        NSLayoutConstraint.activate([
            passportButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            passportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passportButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            passportButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            detailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
    }
    
    
    
}
