//
//  ProModifiedViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 15/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import GeoFire

class ProModifiedViewController : UIViewController {
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var profileImageUrl = "none"
    var oldPlaceID = "none"
    var newPlaceID = "none"
    var listener: ListenerRegistration?
    let geofireRef = Database.database().reference()
    var geoFire: GeoFire?
    var companyInfo = [String: Any]()
    var profileViewController: ProfileViewController?

    
    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        label.isUserInteractionEnabled = true

        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModifiedPro)))
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModifiedJob)))
        return label
    }()
    
    let jobAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModifiedPro)))
        return label
    }()
    
    let jobSectorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModifiedPro)))
        return label
    }()
    
    lazy var modifiedImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "validate")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleValidate)))
        return imageView
    }()
    
    @objc private func handleValidate() {
        print("try to validate")
        navigationController?.popViewController(animated: true)
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
        textView.text = "Lorsque vous modifiez votre poste ou votre entreprise, \n la fiche professionnelle est automatiquement historisée. \n Retrouvez-la dans historique professionnel"
        return textView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileViewController?.boolBurger = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()

        
        // Get profileImageUrl
        if profileImageUrl != "none" {
            self.displayProfileImage(imageUrl: profileImageUrl, imageView: profileImageView)
        }
        
        // Setup Views
        setupViews()
        
        // Init Click on Views
        companyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModifiedPro)))
        jobAddressLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModifiedPro)))
        jobSectorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModifiedPro)))
        jobLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModifiedJob)))
        
        
        // Init GeoFire
        geoFire = GeoFire(firebaseRef: geofireRef.child("companies_geofire"))


    }
    @objc private func handleModifiedJob(){
        print("try to modified job")
        let jobModifiedViewController = JobModifiedViewController()
        if self.profileImageUrl != "none" {
            jobModifiedViewController.profileImageUrl = self.profileImageUrl
        }
        
        if self.oldPlaceID != "none" {
            jobModifiedViewController.placeID = self.oldPlaceID
        }
        
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(jobModifiedViewController, animated: true)
        }
        
    }
    
    
    @objc private func handleModifiedPro(){
        print("try to modified info pro")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.navigationController?.searchDisplayController?.searchBar.placeholder = "eiodfheiuho"
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.types.rawValue) | UInt(GMSPlaceField.viewport.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.country = "fr"
        filter.type = .establishment
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDataIRT()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.remove()
    }
    
    
    private func fetchDataIRT(){
        guard let uid = auth.currentUser?.uid else {return}
        
       listener = db.collection("users").document(uid).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("failed to get userInfo: \(error)")
                return
            }
            
            guard let document = documentSnapshot?.data() else {return}
            
            let userInfo = UserInfo(dictionary: document)
            
            if let jobCompanyName = userInfo.jobCompanyName, let job = userInfo.job, let jobCityAddress = userInfo.jobFormattedAddress, let jobSector = userInfo.jobSector, let profileImageUrlThumbnail = userInfo.profileImageUrlThumbnail, let placeID = userInfo.jobPlaceId  {
                self.oldPlaceID = placeID
                self.companyLabel.text = jobCompanyName
                self.jobLabel.text = job
                self.jobAddressLabel.text = jobCityAddress
                self.jobSectorLabel.text = jobSector
                self.displayProfileImage(imageUrl: profileImageUrlThumbnail, imageView: self.profileImageView)
            }
        }
    }
    
    
    
    private func setupViews(){
        view.addSubview(profileImageView)
        view.addSubview(companyLabel)
        view.addSubview(jobLabel)
        view.addSubview(jobAddressLabel)
        view.addSubview(jobSectorLabel)
        
        view.addSubview(modifiedImageView)
        view.addSubview(firstIndicationTextView)
        
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 130),
            profileImageView.widthAnchor.constraint(equalToConstant: 130)
            ])

        
        NSLayoutConstraint.activate([
            companyLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
            companyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            companyLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            companyLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            jobLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jobLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor),
            jobLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            jobLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            jobAddressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jobAddressLabel.topAnchor.constraint(equalTo: jobLabel.bottomAnchor),
            jobAddressLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            jobAddressLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            jobSectorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jobSectorLabel.topAnchor.constraint(equalTo: jobAddressLabel.bottomAnchor),
            jobSectorLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            jobSectorLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            modifiedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modifiedImageView.topAnchor.constraint(equalTo: jobSectorLabel.bottomAnchor, constant: -10),
            modifiedImageView.heightAnchor.constraint(equalToConstant: 50),
            modifiedImageView.widthAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            firstIndicationTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstIndicationTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            firstIndicationTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            firstIndicationTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            firstIndicationTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08)
            ])
    }
}


extension ProModifiedViewController: GMSAutocompleteViewControllerDelegate {
    
//    private func checkIfJobAlreadyDoneBeforeInFirestore(uid: String, newPlaceID: String, oldPlaceID: String){
//        self.db.collection("users").document(uid).collection("jobs").document(newPlaceID).getDocument { (documentSnapshot, error) in
//            if let error = error {
//                print("failed to check if document exist: \(error)")
//                return
//            }
//
//            guard let documentSnapshot = documentSnapshot else {return}
//
////            if documentSnapshot.exists {
////                // Already do the job
////                print("already worked on this place")
////
//////                guard let document = documentSnapshot.data() else {return}
//////                let jobInfo = JobInfo(dictionary: document)
//////                if let reviewNumber = jobInfo.reviewNumber, let thanks = jobInfo.thanks {
//////                }
////                // set timestamp
////            } else {
////                // Never do the job
////
////            }
//        }
//    }

    
    private func setJobInfoToFirestore(uid: String, newPlaceID: String, jobCompanyName: String, formattedAddress: String, jobSector: String, coordinate: GeoPoint){
        let batch = self.db.batch()
        let refUsers = self.db.collection("users").document(uid)
        let refCompany = self.db.collection("companies").document(newPlaceID)
        let refJobs = self.db.collection("users").document(uid).collection("jobs").document(newPlaceID)
        let refJobsOldPlaceId = self.db.collection("users").document(uid).collection("jobs").document(oldPlaceID)

        batch.setData([
            "jobGpsLocation": coordinate,
            "jobPlaceId": newPlaceID,
            "jobCompanyName": jobCompanyName,
            "jobFormattedAddress": formattedAddress,
            "jobSector": jobSector,
            "isPro": true
            ] as [String : Any], forDocument: refUsers, merge: true)
        
        batch.setData(self.companyInfo, forDocument: refCompany, merge: true)
        
        batch.setData([
            "jobCompanyName": jobCompanyName,
            "jobFormattedAddress": formattedAddress,
            "jobSector": jobSector,
            "timestampBegin": FieldValue.serverTimestamp(),
            ] as [String : Any], forDocument: refJobs, merge: true)
        
        if self.oldPlaceID != "none" {
            batch.setData([
                "timestampEnd": FieldValue.serverTimestamp(),
                ] as [String : Any], forDocument: refJobsOldPlaceId, merge: true)
        }
        
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
                self.setPlaceIdGeofire(positionPlace: coordinate, placeId: newPlaceID)
                self.dismiss(animated: true, completion: nil)

            }
        }
    }
    
    private func setPlaceIdGeofire(positionPlace: GeoPoint, placeId: String){
        geoFire?.setLocation(CLLocation(latitude: positionPlace.latitude, longitude: positionPlace.longitude), forKey: placeId) { (error) in
            if let error = error {
                print("geofire An error occured: \(error)")
            } else {
                print("geofire Saved location successfully proModifiedViewController!")
            }
        }
    }
    

    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let placeID = place.placeID ?? "none"
        self.newPlaceID = placeID
        // If user click on the same company than he's working, juste don't do anything
        if self.oldPlaceID == self.newPlaceID {
            return
        }

        let jobCompanyName = place.name ?? "none"
        let formattedAddress = place.formattedAddress ?? "none"
        let types = place.types
        let jobSector = types?[0] ?? ""
        let coordinate = GeoPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let northEastCoordinate = GeoPoint(latitude: place.viewport?.northEast.latitude ?? 1, longitude: place.viewport?.northEast.longitude ?? 1)
        let southWestCoordinate = GeoPoint(latitude: place.viewport?.southWest.latitude ?? 1, longitude: place.viewport?.southWest.longitude ?? 1)
        let center = GeoPoint(latitude: 1, longitude: 1)
        let radius = "100"
        
        
        companyLabel.text = jobCompanyName
        jobAddressLabel.text = formattedAddress
        jobSectorLabel.text = jobSector
        
        guard let uid = auth.currentUser?.uid else {return}
        
        
        
        companyInfo = [
            "placeID": placeID,
            "name":  jobCompanyName,
            "coordinate": coordinate,
            "formattedAddress": formattedAddress ,
            "northEastCoordinate": northEastCoordinate,
            "southWestCoordinate": southWestCoordinate,
            "types": FieldValue.arrayUnion(types ?? ["none"]),
            "center": center,
            "radius": radius
            ] as [String : Any]
        
        setJobInfoToFirestore(uid: uid, newPlaceID: newPlaceID, jobCompanyName: jobCompanyName, formattedAddress: formattedAddress, jobSector: jobSector, coordinate: coordinate)
        
        print("Place name: \(place.name as Optional)")
        print("Place ID: \(place.placeID as Optional)")
        print("Place coordinate: \(place.coordinate as Optional)")
        print("Place formattedAddress: \(place.formattedAddress as Optional)")
        
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
