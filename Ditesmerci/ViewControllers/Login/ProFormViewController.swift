//
//  ProFormViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 21/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import GeoFire

class ProFormViewController: UIViewController, UITextFieldDelegate {
    var db: Firestore!
    var auth = Auth.auth()
    var alertController: UIAlertController?
    let placesClient = GMSPlacesClient()
    var companyInfo = [String: Any]()
    var placeID = String()
    let geofireRef = Database.database().reference()
    var geoFire: GeoFire?
    var coordinate: GeoPoint?
    var isAlreadyProfileImage = false
    
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
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let createProFormLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CRÉER VOTRE FICHE PROFESSIONNELLE"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let jobTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Emploi"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    let companyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Entreprise"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.addTarget(self, action: #selector(handleAutocomplete), for: .touchDown)
        
        return textField
    }()
    let addressTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Adresse du lieu de travail"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.isHidden = true
        
        
        return textField
    }()
    let sectorTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Secteur"
        textField.layer.borderColor = UIColor.purpleMerci.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.alphabet
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.isHidden = true
        
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
        button.addTarget(self, action: #selector(handleSendProInfo), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let ignoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("IGNORER POUR L'INSTANT", for: .normal)
        button.backgroundColor = .blueMerci
        button.addTarget(self, action: #selector(handleIgnore), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    let indicationTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Vos informations professionnelles pourront être complétées ultérieurement. En attendant vous pouvez envoyer des 'Merci' mais pas en recevoir."
        textView.font = UIFont.boldSystemFont(ofSize: 10)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()
    
    @objc private func handleSendProInfo(){
        print("try to send pro info")
        alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController!)
        
        let job = jobTextField.text ?? "none"
        let jobCompanyName = companyTextField.text ?? "none"
        let jobFormattedAddress = addressTextField.text ?? "none"
        let jobSector = sectorTextField.text ?? "none"
        
        // If textfield fill create/update a document inside the collection companies with companyInfo & update the user's document with some additionnal data
        if(!job.isEmpty && !jobCompanyName.isEmpty && !jobFormattedAddress.isEmpty && !jobSector.isEmpty){
            setDataToServer(positionPlace: self.coordinate ?? GeoPoint(latitude: 1, longitude: 1), job: job, jobCompanyName: jobCompanyName, jobFormattedAddress: jobFormattedAddress, jobSector: jobSector, jobPlaceId: placeID, isPro: true)
        } else {
            print("Didn't write all textfield")
            self.alertController?.dismiss(animated: true, completion: {
                self.displayAlertErrorUI(title: "Erreur", message: "Remplissez tous les champs s'il vous plaît.", answer: "ok")
            })
        }
    }
    
    
    private func setDataToServer(positionPlace: GeoPoint, job: String, jobCompanyName: String, jobFormattedAddress: String, jobSector: String, jobPlaceId: String, isPro: Bool){
        guard let uid = auth.currentUser?.uid else {return}
        
        geoFire?.setLocation(CLLocation(latitude: positionPlace.latitude, longitude: positionPlace.longitude), forKey: placeID) { (error) in
            if (error != nil) {
                print("geofire An error occured: \(error?.localizedDescription ?? "none")")
                self.alertController?.dismiss(animated: true, completion: {
                    self.displayAlertErrorUI(title: "Erreur", message: "Une erreur est surevenu, réessayez avec une meilleur connexion internet.", answer: "ok")
                })
                return
            } else {
                print("geofire Saved location successfully!")
                self.db.collection("companies").document(self.placeID).setData(self.companyInfo as [String : Any], merge: true, completion: { err in
                    if let err = err {
                        print("Failed store companyInfo: \(err)")
                        self.alertController?.dismiss(animated: true, completion: {
                            self.displayAlertErrorUI(title: "Erreur", message: "Une erreur est surevenu, réessayez avec une meilleur connexion internet.", answer: "ok")
                        })
                        return
                    }
                    print("Succeed store companyInfo")
                    self.db.collection("users").document(uid).setData([
                        "job": job,
                        "jobCompanyName": jobCompanyName,
                        "jobFormattedAddress": jobFormattedAddress,
                        "jobSector": jobSector,
                        "jobPlaceId": self.placeID,
                        "isPresent": false,
                        "isPro": true
                        ] as [String : Any], merge: true, completion: { err in
                            if let err = err {
                                print("Failed store userInfo: \(err)")
                                self.alertController?.dismiss(animated: true, completion: nil)
                                return
                            }
                            self.db.collection("users").document(uid).collection("jobs").document(self.placeID).setData([
                                "job": job,
                                "jobCompanyName": jobCompanyName,
                                "jobFormattedAddress": jobFormattedAddress,
                                "jobSector": jobSector,
                                "timestampBegin": FieldValue.serverTimestamp(),
                                "thanks": 0,
                                "reviewNumber": 0
                                ] as [String : Any], merge: true, completion: { err in
                                    if let err = err {
                                        print("Failed store proInfo: \(err)")
                                        self.alertController?.dismiss(animated: true, completion: nil)
                                        
                                    } else {
                                        print("Succeed store proInfo")
                                        
                                        self.alertController?.dismiss(animated: true, completion: {
                                            if(self.isAlreadyProfileImage) {
                                                let tabBarController = TabBarController()
                                                tabBarController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                                                self.present(tabBarController, animated: true, completion: nil)
                                            } else {
                                                let pictureViewController = PictureViewController()
                                                pictureViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                                                self.present(pictureViewController, animated: true, completion: nil)
                                            }
                                            
                                        })
                                    }
                            })
                                
                        })
                })
            }
        }
        
    }
    
    
    @objc func handleIgnore(_ sender: UIButton) {
        self.present(TabBarController(), animated: true, completion: nil)
    }
    
    @objc private func handleAutocomplete(){
        print("try to start auto completion google places")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.types.rawValue) | UInt(GMSPlaceField.viewport.rawValue) )!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.country = "fr"
        filter.type = .establishment
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem

        self.hideKeyboardWhenTappedAround()
        db = Firestore.firestore()
        geoFire = GeoFire(firebaseRef: geofireRef.child("companies_geofire"))
        
        jobTextField.delegate = self
        companyTextField.delegate = self
        addressTextField.delegate = self
        sectorTextField.delegate = self
        setupViews()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == jobTextField){
            return true
        }
        if(string == " ") {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == jobTextField || textField == companyTextField || textField == addressTextField){
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == jobTextField || textField == companyTextField || textField == addressTextField){
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
    }
    
    
    func setupViews() {
        view.backgroundColor = .white
        setupTopLogoImageView()
        setupFormContainerView()
        setupBottomViews()
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
        formContainerView.addSubview(createProFormLabel)
        formContainerView.addSubview(jobTextField)
        formContainerView.addSubview(companyTextField)
        formContainerView.addSubview(addressTextField)
        formContainerView.addSubview(sectorTextField)
        formContainerView.addSubview(dividerLineView)
        formContainerView.addSubview(sendButton)
        
        
        self.addConstraintFromView(subview: formContainerView, attribute: .centerY, multiplier: 1.2, identifier: "formContainerView placement Y")
        NSLayoutConstraint.activate([
            formContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            formContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: paddingTextField(positive: true)),
            formContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: paddingTextField(positive: false)),
            formContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
            ])
        NSLayoutConstraint.activate([
            createProFormLabel.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            createProFormLabel.topAnchor.constraint(equalTo: formContainerView.topAnchor),
            createProFormLabel.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            createProFormLabel.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            createProFormLabel.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.10)
            ])
        NSLayoutConstraint.activate([
            jobTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            jobTextField.topAnchor.constraint(equalTo: createProFormLabel.bottomAnchor),
            jobTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            jobTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            jobTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.12)
            ])
        NSLayoutConstraint.activate([
            companyTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            companyTextField.topAnchor.constraint(equalTo: jobTextField.bottomAnchor, constant: 10),
            companyTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            companyTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            companyTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.12)
            ])
        NSLayoutConstraint.activate([
            addressTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            addressTextField.topAnchor.constraint(equalTo: companyTextField.bottomAnchor, constant: 10),
            addressTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            addressTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            addressTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.12)
            ])
        NSLayoutConstraint.activate([
            sectorTextField.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            sectorTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 10),
            sectorTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            sectorTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            sectorTextField.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.12)
            ])
        NSLayoutConstraint.activate([
            dividerLineView.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            dividerLineView.topAnchor.constraint(equalTo: sectorTextField.bottomAnchor, constant: 10),
            dividerLineView.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor),
            dividerLineView.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            dividerLineView.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.012)
            ])
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            sendButton.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor),
            sendButton.heightAnchor.constraint(equalTo: formContainerView.heightAnchor, multiplier: 0.12)
            ])
        
    }
    
    private func setupBottomViews(){
        view.addSubview(bottomView)
        //bottomView.backgroundColor = .red
        
        bottomView.addSubview(ignoreButton)
        bottomView.addSubview(indicationTextView)
        
        self.addConstraintFromView(subview: bottomView, attribute: .centerY, multiplier: 1.8, identifier: "bottomView placement Y")
        NSLayoutConstraint.activate([
            bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.topAnchor.constraint(equalTo: formContainerView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
            ])
        
        NSLayoutConstraint.activate([
            ignoreButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            ignoreButton.topAnchor.constraint(equalTo: bottomView.topAnchor),
            ignoreButton.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.45),
            ignoreButton.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.20),
            ])
        
        NSLayoutConstraint.activate([
            indicationTextView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            indicationTextView.topAnchor.constraint(equalTo: ignoreButton.bottomAnchor),
            indicationTextView.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 1),
            indicationTextView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 4/6),
            ])
        
    }
    
    
    func getDataFromPlaceId(){
        // A hotel in Saigon with an attribution.
        let placeID = "ChIJ-6rPewJl5kcRMh3-RzGafYs"
        
        
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
            (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                print("The selected place is: \(place.name ?? "none")")
                print("Place ID: \(place.placeID as Optional)")
            }
        })
    }
}



extension ProFormViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.placeID = place.placeID ?? "none"
        let name = place.name ?? "none"
        coordinate = GeoPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let formattedAddress = place.formattedAddress ?? "none"
        let northEastCoordinate = GeoPoint(latitude: place.viewport?.northEast.latitude ?? -89, longitude: place.viewport?.northEast.longitude ?? -89)
        let southWestCoordinate = GeoPoint(latitude: place.viewport?.southWest.latitude ?? -89, longitude: place.viewport?.southWest.longitude ?? -89)
        let types = place.types
        
        let center = GeoPoint(latitude: 1, longitude: 1)
        let radius = "30"
        
        
        companyInfo = [
            "placeID": placeID,
            "name":  name ,
            "coordinate": coordinate ?? GeoPoint(latitude: 1, longitude: 1),
            "formattedAddress": formattedAddress ,
            "northEastCoordinate": northEastCoordinate,
            "southWestCoordinate": southWestCoordinate,
            "types": FieldValue.arrayUnion(types ?? ["none"]),
            "center": center,
            "radius": radius
            ] as [String : Any]
        
        addressTextField.isHidden = false
        sectorTextField.isHidden = false
        
        companyTextField.text = name
        addressTextField.text = formattedAddress
        sectorTextField.text = types?[0] ?? ""
        
        
        print("Place name: \(place.name as Optional)")
        print("Place ID: \(place.placeID as Optional)")
        //        print("Place attributions: \(place.attributions as Optional)")
        //        print("Place website: \(place.website as Optional)")
        //        print("Place addressComponents: \(place.addressComponents as Optional)")
        print("Place coordinate: \(place.coordinate as Optional)")
        print("Place formattedAddress: \(place.formattedAddress as Optional)")
        //        print("Place openingHours: \(place.openingHours as Optional)")
        //        print("Place phoneNumber: \(place.phoneNumber as Optional)")
        //        print("Place plusCode: \(place.plusCode as Optional)")
        //        print("Place viewport: \(place.viewport as Optional)")
        //        print("Place types: \(place.types as Optional)")
        //        print("northEastCoordinate \(northEastCoordinate as Optional)")
        //        print("southWestCoordinate \(southWestCoordinate as Optional)")
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
