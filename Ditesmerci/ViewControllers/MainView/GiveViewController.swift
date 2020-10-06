//
//  GiveViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 13/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class GiveViewController: UIViewController, UITextViewDelegate {
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var user: User?
    var uid: String?
    var employee: UserInfo?
    var employeeUid: String?
    var tap: UITapGestureRecognizer?
    var isThanked = false
    var isReviewVisible = false
    var isPourboire = false
    var isNeverThanksHim = false
    var isNeverReviewedHim = false
    var isNeverPourboireHim = false
    var alreadyThanksListener: ListenerRegistration?
    var alreadyReviewedListener: ListenerRegistration?
    var alreadyPourboireListener: ListenerRegistration?

    lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "banner")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var merciImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "thanks")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0.3
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMerci)))

        
        return imageView
    }()
    
    
    lazy var reviewImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "review")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0.3
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReview)))

        return imageView
    }()
    
    lazy var pourboireImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "pourboire")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0.3
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePourboire)))

        return imageView
    }()
    
    
    let labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isHidden = true
        return view
    }()
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Laissez votre commentaire \n 140 caractères max"
        textView.textColor = .lightGray
        textView.backgroundColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.keyboardType = UIKeyboardType.alphabet

        return textView
    }()
    
    lazy var validationImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "validate")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSendReview)))
        return imageView
    }()
    
    
    @objc private func handleMerci(){
        print("try to send 'merci' to the employee")
        if self.isThanked {
            let alert = UIAlertController(title: "Demande de suppression de merci", message: "Votre merci et vos messages ne seront plus visibles par le professionnel mais vous pourrez les rétablir à tout moment.", preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Oui", style: .destructive, handler: { (_) in
                self.setNoMerciToFirestore()
            })
            let cancel = UIAlertAction(title: "Non", style: .default, handler: { (action) -> Void in })
            alert.addAction(submitAction)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        } else {
            setMerciToFirestore()
        }
    }
    
    
    private func setMerciToFirestore(){
        print("try to set merci to firestore")
        db.collection("users").document(uid!).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            guard let document = documentSnapshot?.data() else {return}
            let userInfo = UserInfo(dictionary: document)
            
            guard let uid = self.auth.currentUser?.uid, let employeeUid = self.employee?.uid, let jobPlaceID = self.employee?.jobPlaceId else {return}
            if self.isNeverThanksHim {
                // never Thanked him
                self.db.collection("users").document(employeeUid).collection("merci").document(uid).setData([
                    "clientFirstName": userInfo.firstName ?? "none",
                    "clientProfileImageUrl": userInfo.profileImageUrlThumbnail ?? "none",
                    "clientUid": uid,
                    "isThanked": true,
                    "timestampCreation": FieldValue.serverTimestamp(),
                    "timestampModification": FieldValue.serverTimestamp()
                    
                    ] as [String : Any], merge: true, completion: { err in
                        if let err = err {
                            print("Failed store userInfo: \(err)")
                            
                        } else {
                            print("Succeed store userInfo")
                            self.isNeverThanksHim = false
                            self.incrementIntoFirestore(employeeUid: employeeUid, jobPlaceId: jobPlaceID, number: 1, isThanks: true)
                        }
                })
            } else {
                // already Thanked him
                if self.isNeverReviewedHim {
                    //never Reviewed him
                    self.db.collection("users").document(employeeUid).collection("merci").document(uid).setData([
                        "clientFirstName": userInfo.firstName ?? "none",
                        "clientProfileImageUrl": userInfo.profileImageUrlThumbnail ?? "none",
                        "clientUid": uid,
                        "isThanked": true,
                        ] as [String : Any], merge: true, completion: { err in
                            if let err = err {
                                print("Failed store userInfo: \(err)")
                                return
                            }
                            print("Succeed store userInfo")
                            self.incrementIntoFirestore(employeeUid: employeeUid, jobPlaceId: jobPlaceID, number: 1, isThanks: true)
                    })
                } else {
                    //already Reviewed him
                    if self.isNeverPourboireHim {
                        // Never Pourboire Him
                        self.db.collection("users").document(employeeUid).collection("merci").document(uid).setData([
                            "clientFirstName": userInfo.firstName ?? "none",
                            "clientProfileImageUrl": userInfo.profileImageUrlThumbnail ?? "none",
                            "clientUid": uid,
                            "isThanked": true,
                            "isReviewVisible": true
                            ] as [String : Any], merge: true, completion: { err in
                                if let err = err {
                                    print("Failed store userInfo: \(err)")
                                    return
                                }
                                print("Succeed store userInfo")
                                self.incrementIntoFirestore(employeeUid: employeeUid, jobPlaceId: jobPlaceID, number: 1, isThanks: true)
                                self.setReviewIsVisibleTrueToFirestore(employeeUid: employeeUid, jobPlaceID: jobPlaceID)
                        })
                    } else {
                        // Already Pourboire Him
                        self.db.collection("users").document(employeeUid).collection("merci").document(uid).setData([
                            "clientFirstName": userInfo.firstName ?? "none",
                            "clientProfileImageUrl": userInfo.profileImageUrlThumbnail ?? "none",
                            "clientUid": uid,
                            "isThanked": true,
                            "isReviewVisible": true,
                            "isPourboire": true,
                            
                            ] as [String : Any], merge: true, completion: { err in
                                if let err = err {
                                    print("Failed store userInfo: \(err)")
                                    return
                                }
                                print("Succeed store userInfo")
                                self.incrementIntoFirestore(employeeUid: employeeUid, jobPlaceId: jobPlaceID, number: 1, isThanks: true)
                                self.setReviewIsVisibleTrueToFirestore(employeeUid: employeeUid, jobPlaceID: jobPlaceID)
                        })
                    }
                }
            }
            
        }
        
    }
    
    private func setNoMerciToFirestore(){
        print("try to set no merci to Firestore")
        guard let uid = auth.currentUser?.uid, let employeeUid = employee?.uid, let jobPlaceID = employee?.jobPlaceId  else {return}
        db.collection("users").document(employeeUid).collection("merci").document(uid).setData([
            "isThanked": false,
            "isReviewVisible": false,
            "isPourboire": false,
            "timestampModification": FieldValue.serverTimestamp(),
            ] as [String : Any], merge: true, completion: { err in
                if let err = err {
                    print("Failed store userInfo: \(err)")
                    return
                }
                print("Succeed store userInfo")
                self.incrementIntoFirestore(employeeUid: employeeUid, jobPlaceId: jobPlaceID, number: -1, isThanks: true)
                self.db.collection("users").document(employeeUid).collection("reviews").whereField("clientUid", isEqualTo: uid).getDocuments(completion: { (querySnapshot, error) in
                    if error != nil {
                        print("Error to get reviews of current uid : \(error?.localizedDescription ?? "none")")
                        return
                    }
                    guard let documents = querySnapshot?.documents else {
                        return
                    }
                    let reviewNumberOfCurrentUid = documents.count
                    self.incrementIntoFirestore(employeeUid: employeeUid, jobPlaceId: jobPlaceID, number: -reviewNumberOfCurrentUid, isThanks: false)
                    self.setIsReviewVisibleFalseToFirestore(documents: documents, employeeUid: employeeUid)
                    
                })
        })
    }
    
    @objc private func handleSendReview(){
        print("Try to send review")
        validationImageView.isUserInteractionEnabled = false
        if let reviewText = reviewTextView.text {
            if reviewText.isEmpty || reviewText == "Laissez votre commentaire \n 140 caractères max" {
                self.displayAlertErrorUI(title: "", message: "Ecrivez quelque chose avant de l'envoyer", answer: "ok")
                self.validationImageView.isUserInteractionEnabled = true
                return
            }
            sendReviewToFirestore(reviewText: reviewText)
        }
    }

    private func sendReviewToFirestore(reviewText: String){
        db.collection("users").document(uid!).getDocument { (documentSnapshot, error) in
            if error != nil {
                print("error to get \(self.uid!) document: \(error?.localizedDescription ?? "none")")
                self.validationImageView.isUserInteractionEnabled = true
                return
            }
            
            guard let document = documentSnapshot?.data() else {
                self.validationImageView.isUserInteractionEnabled = true
                return
            }
            
            let userInfo = UserInfo(dictionary: document)
            
            let uuid = UUID().uuidString
            if let employeeUid = self.employee?.uid, let jobPlaceID = self.employee?.jobPlaceId {
                self.db.collection("users").document(employeeUid).collection("reviews").document(uuid).setData([
                    "clientFirstName": userInfo.firstName ?? "none",
                    "clientProfileImageUrl": userInfo.profileImageUrlThumbnail ?? "none",
                    "clientUid": self.uid ?? "none",
                    "isAddedToCv": false,
                    "isOpen": false,
                    "isReviewVisible": true,
                    "jobPlaceId": jobPlaceID,
                    "review": reviewText,
                    "timestampCreation": FieldValue.serverTimestamp(),
                    "timestampModification": FieldValue.serverTimestamp(),
                    
                    
                    ] as [String : Any], merge: true, completion: { err in
                        if let err = err {
                            print("Failed store userInfo: \(err)")
                            self.validationImageView.isUserInteractionEnabled = true
                        } else {
                            print("Succeed store userInfo")
                            self.db.collection("users").document(employeeUid).collection("merci").document(self.uid!).setData([
                                "reviewsIDs": FieldValue.arrayUnion([uuid]),
                                "isReviewVisible": true,
                                ] as [String : Any], merge: true, completion: { err in
                                    if let err = err {
                                        print("Failed store userInfo: \(err)")
                                        
                                    } else {
                                        print("Succeed store userInfo")
                                        self.reviewImageView.alpha = 1.0
                                        self.incrementIntoFirestore(employeeUid: employeeUid, jobPlaceId: jobPlaceID, number: 1, isThanks: false)
                                        self.hideReviewView()
                                        self.isReviewVisible = true
                                        self.validationImageView.isUserInteractionEnabled = true

                                    }
                            })
                        }
                })
            }
        }
    }
    
    private func incrementIntoFirestore(employeeUid: String, jobPlaceId: String, number: Int, isThanks: Bool){
        let batch = self.db.batch()
        let refUsers = self.db.collection("users").document(employeeUid)
        let refJobs = self.db.collection("users").document(employeeUid).collection("jobs").document(jobPlaceId)
        let fieldName: String
        if isThanks {
            fieldName = "thanks"
        } else {
            fieldName = "reviewNumber"
        }
        
        batch.setData([
            fieldName: FieldValue.increment(Int64(number))
            ] as [String : Any], forDocument: refUsers, merge: true)
        
        batch.setData([
            fieldName: FieldValue.increment(Int64(number))
            ] as [String : Any], forDocument: refJobs, merge: true)
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
        
    }
    

    private func displayChoice(){
        let alert = UIAlertController(title: "Demande de suppression de merci", message: "Voulez-vous vraiment supprimer votre merci?", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Oui", style: .destructive, handler: { (_) in

        })
        let cancel = UIAlertAction(title: "Non", style: .default, handler: { (action) -> Void in })
        alert.addAction(submitAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    private func setIsReviewVisibleFalseToFirestore(documents: [QueryDocumentSnapshot], employeeUid: String) {
        let batch = db.batch()
        for document in documents {
            let documentId = document.documentID
            let refReview = db.collection("users").document(employeeUid).collection("reviews").document(documentId)
            batch.setData([
                "isReviewVisible": false,
                "isAddedToCv": false,

                ] as [String : Any], forDocument: refReview, merge: true)
        }
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    
    
    
    private func setReviewIsVisibleTrueToFirestore(employeeUid: String, jobPlaceID: String){
        db.collection("users").document(employeeUid).collection("merci").document(self.uid!).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("failed to fetch document of \(employeeUid) to get the reviewID: \(error)")
                return
            }

            guard let document = documentSnapshot?.data() else {
                return
            }
            
            let merciInfo = MerciInfo(dictionary: document)
            guard let reviewsIDs = merciInfo.reviewsIDs else {return}
            if reviewsIDs.count > 0 {
                let batch = self.db.batch()
                let reviewNumber = reviewsIDs.count
                self.incrementIntoFirestore(employeeUid: employeeUid, jobPlaceId: jobPlaceID, number: reviewNumber, isThanks: false)
                
                for documentId in reviewsIDs {
                    let refReview = self.db.collection("users").document(employeeUid).collection("reviews").document(documentId)
                    batch.setData([
                        "isReviewVisible": true,
                        ] as [String : Any], forDocument: refReview, merge: true)
                }
                
                batch.commit() { err in
                    if let err = err {
                        print("Error writing batch \(err)")
                    } else {
                        print("Batch isVisible true write succeeded.")
                    }
                }
            }
        }
    }

    
    @objc private func handleReview(){
        print("try to write a review to the employee")
        if self.isThanked {
            displayReviewView()

            
        } else {
            print("Thanks before")
            self.displayAlertErrorUI(title: "", message: "Vous devez d'abord remercier une personne avant de lui laisser un avis.", answer: "ok")
            
        }
        
        
//        if self.isReviewVisible {
//            print("already send a review")
//
//        }
        
    }
    
    
    private func displayReviewView(){
        overlayView.isHidden = false
        tapToHideReviewView()
        view.bringSubviewToFront(overlayView)
    }
    
    @objc private func hideReviewView(){
        overlayView.isHidden = true
        self.reviewTextView.text = "Laissez votre commentaire \n 140 caractères max"
        self.reviewTextView.textColor = .lightGray
        self.reviewTextView.centerVertically()

        dismissKeyboard()
        if tap != nil {
            view.removeGestureRecognizer(tap!)
        }

    }
    
    
    @objc private func handlePourboire(){
        print("try to send a 'pourboire' to the employee")
        if isReviewVisible {
            let pourboireVC = PourboireVC()
            pourboireVC.employeeUid = employeeUid
            DispatchQueue.main.async {
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(pourboireVC, animated: true)
            }
        } else {
            displayAlertErrorUI(title: "", message: "Ecrivez d'abord un avis sur la personne et vous pourrez lui donner un pourboire.", answer: "OK")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupBackButton()
        reviewTextView.delegate = self
        view.backgroundColor = .white
        user = auth.currentUser
        uid = user?.uid
        setupNavigationBar()
        setupNavigationBar1()
        setupViews()

        
        //setupBow()
        fetchDataEmployee()
        isAlreadyThanked()
        isAlreadyReviewed()
        isAlreadyPourboire()
    }
    func setupNavigationBar1(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBackTapped))
    }
    
    @objc private func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        reviewTextView.centerVertically()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alreadyThanksListener?.remove()
        alreadyReviewedListener?.remove()
        alreadyPourboireListener?.remove()
    }


    private func isAlreadyThanked() {
        guard let uid = auth.currentUser?.uid else {return}
        
        self.db.collection("users").document(self.employeeUid!).collection("merci").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return
            }
            
            guard let documentSnapshot = documentSnapshot else {return}
            if documentSnapshot.exists {
                self.isNeverThanksHim = false
                self.alreadyThanksListener = self.db.collection("users").document(self.employeeUid!).collection("merci").whereField("clientUid", isEqualTo: uid).whereField("isThanked", isEqualTo: true).addSnapshotListener { (querySnapshot, error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let querySnapshot = querySnapshot else {return}
                    
                    if querySnapshot.isEmpty {
                        self.isThanked = false
                        DispatchQueue.main.async {
                            self.merciImageView.alpha = 0.3
                        }
                    } else {
                        self.isThanked = true
                        DispatchQueue.main.async {
                            self.merciImageView.alpha = 1.0
                        }
                    }
                }
            } else {
                self.isNeverThanksHim = true
                self.isThanked = false
                DispatchQueue.main.async {
                    self.merciImageView.alpha = 0.3
                }
            }
        }
    }
    
    private func isAlreadyReviewed() {
        guard let uid = auth.currentUser?.uid else {return}
        self.db.collection("users").document(self.employeeUid!).collection("reviews").whereField("clientUid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return
            }
            
            guard let querySnapshot = querySnapshot else {return}
            if !querySnapshot.isEmpty {
                self.isNeverReviewedHim = false
                self.alreadyPourboireListener = self.db.collection("users").document(self.employeeUid!).collection("merci").document(uid).addSnapshotListener({ (documentSnapshot, error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documentSnapshot = documentSnapshot else {return}
                    let merciInfo = MerciInfo(dictionary: documentSnapshot.data()!)
                    if merciInfo.isReviewVisible! {
                        self.isReviewVisible = true
                        DispatchQueue.main.async {
                            self.reviewImageView.alpha = 1.0
                        }
                        
                    } else {
                        self.isReviewVisible = false
                        DispatchQueue.main.async {
                            self.reviewImageView.alpha = 0.3
                        }
                    }
                })
            } else {
                // Never reviewed Him
                self.isNeverReviewedHim = true
                self.isReviewVisible = false
                DispatchQueue.main.async {
                    self.reviewImageView.alpha = 0.3
                }
            }
        }
    }
    
    private func isAlreadyPourboire() {
        guard let uid = auth.currentUser?.uid else {return}
        self.db.collection("users").document(self.employeeUid!).collection("pourboire").whereField("clientUid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return
            }
            guard let querySnapshot = querySnapshot else {return}
            if !querySnapshot.isEmpty {
                self.isNeverPourboireHim = false
                
                self.alreadyPourboireListener = self.db.collection("users").document(self.employeeUid!).collection("merci").document(uid).addSnapshotListener({ (documentSnapshot, error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documentSnapshot = documentSnapshot else {return}
                    let merciInfo = MerciInfo(dictionary: documentSnapshot.data()!)
                    if merciInfo.isPourboire! {
                        self.isPourboire = true
                        DispatchQueue.main.async {
                            self.pourboireImageView.alpha = 1.0
                        }

                    } else {
                        self.isPourboire = false
                        DispatchQueue.main.async {
                            self.pourboireImageView.alpha = 0.3
                        }
                    }
                })
            } else {
                self.isNeverPourboireHim = true
                self.isPourboire = false
                DispatchQueue.main.async {
                    self.pourboireImageView.alpha = 0.3
                }
            }
        }
    }
    
    private func fetchDataEmployee(){
        print("try to display data employee")
        db.collection("users").document(self.employeeUid!).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("failed to get employeeInfo : \(error)")
                return
            }
            
            guard let document = documentSnapshot?.data() else {return}
            let employee = UserInfo(dictionary: document)
            self.employee = employee
            let firstName = employee.firstName ?? "none"
            let companyName = employee.jobCompanyName ?? "none"
            let job = employee.job ?? "none"
            let formattedAddress = employee.jobFormattedAddress ?? "none"
            if let profileImageUrlThumbnail = employee.profileImageUrlThumbnail {
                self.displayProfileImage(profileImageUrlThumbnail: profileImageUrlThumbnail)
            }
            DispatchQueue.main.async {
                self.nameLabel.text = firstName
                self.companyLabel.text = companyName
                self.jobLabel.text = job.capitalizingFirstLetter()
                self.addressLabel.text = formattedAddress
            }
        }
    }
    
    private func displayDataEmployee(isThanked: Bool, isReviewVisible: Bool, isPourboire: Bool) {
        if isThanked {
            merciImageView.alpha = 1.0
            
        }
        
        if isReviewVisible {
            reviewImageView.alpha = 1.0
        }
        
        if isPourboire {
            pourboireImageView.alpha = 1.0
        }
        
        
    }
    
    
    private func displayProfileImage(profileImageUrlThumbnail: String) {
        let url = URL(string: profileImageUrlThumbnail)
        let placeHolder = UIImage(named: "user")
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
     // MARK: NavigationBar system
     func setupNavigationBar(){
         if let navControllerView = navigationController?.view {
             navControllerView.backgroundColor = .white
             navigationItem.titleView = bannerImageView
             if let bannerImage = bannerImageView.image {
                 bannerImageView.image = bannerImage.resize(targetSize: CGSize(width: 150, height: 33))
             }
         }
     }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 141    // 140 Limit Value
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
        //keyboard up
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 70, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
        if tap != nil {
            view.removeGestureRecognizer(tap!)
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Laissez votre commentaire \n 140 caractères max"
            textView.textColor = .lightGray
            textView.centerVertically()

        }
        tapToHideReviewView()
        
        // Keyboard down
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 70, width:self.view.frame.size.width, height:self.view.frame.size.height);
            
        })
        
    }
    
    
    private func setupBow(){
        let shapeLayer = CAShapeLayer()
        
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/2, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        
        view.layer.addSublayer(shapeLayer)
    }
    
    private func setupReviewViews(){
        overlayView.addSubview(reviewTextView)
        overlayView.addSubview(validationImageView)
        
        NSLayoutConstraint.activate([
            reviewTextView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            reviewTextView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            reviewTextView.heightAnchor.constraint(equalTo: overlayView.heightAnchor, multiplier: 0.25),
            reviewTextView.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.9)
            
            ])
        
        NSLayoutConstraint.activate([
            validationImageView.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: -40),
            validationImageView.rightAnchor.constraint(equalTo: overlayView.rightAnchor, constant: -38),
            validationImageView.heightAnchor.constraint(equalTo: overlayView.heightAnchor, multiplier: 0.13),
            validationImageView.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.13)
            
            ])
        
    }
    
    private func tapToHideReviewView() {
        tap = UITapGestureRecognizer(target: self, action: #selector(hideReviewView))
        tap!.cancelsTouchesInView = false
        view.addGestureRecognizer(tap!)
    }
    
    func setupViews(){
        view.addSubview(profileImageView)
        view.addSubview(labelContainerView)
        labelContainerView.addSubview(nameLabel)
        labelContainerView.addSubview(companyLabel)
        labelContainerView.addSubview(jobLabel)
        labelContainerView.addSubview(addressLabel)
        view.addSubview(merciImageView)
        view.addSubview(reviewImageView)
        view.addSubview(pourboireImageView)
        view.addSubview(overlayView)


        
        
        NSLayoutConstraint.activate([
            merciImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            merciImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            merciImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: (0.15 * view.frame.height)/view.frame.width),
            merciImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
            ])
        
        NSLayoutConstraint.activate([
            reviewImageView.leftAnchor.constraint(equalTo: merciImageView.rightAnchor, constant: -20),
            reviewImageView.topAnchor.constraint(equalTo: merciImageView.bottomAnchor, constant: 0),
            reviewImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: (0.15 * view.frame.height)/view.frame.width),
            reviewImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
            ])
        
        NSLayoutConstraint.activate([
            pourboireImageView.leftAnchor.constraint(equalTo: merciImageView.rightAnchor, constant: -10),
            pourboireImageView.topAnchor.constraint(equalTo: reviewImageView.bottomAnchor, constant: 25),
            pourboireImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: (0.15 * view.frame.height)/view.frame.width),
            pourboireImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
            ])
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -60),
            profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: (0.4 * view.frame.height)/view.frame.width),
            profileImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
            ])
        
        NSLayoutConstraint.activate([
            labelContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            labelContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            labelContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: labelContainerView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor),
            ])
        
        NSLayoutConstraint.activate([
            companyLabel.centerXAnchor.constraint(equalTo: labelContainerView.centerXAnchor),
            companyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            ])
        
        NSLayoutConstraint.activate([
            jobLabel.centerXAnchor.constraint(equalTo: labelContainerView.centerXAnchor),
            jobLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor),
            ])
        
        NSLayoutConstraint.activate([
            addressLabel.centerXAnchor.constraint(equalTo: labelContainerView.centerXAnchor),
            addressLabel.topAnchor.constraint(equalTo: jobLabel.bottomAnchor),
            addressLabel.leftAnchor.constraint(equalTo: labelContainerView.leftAnchor),
            addressLabel.rightAnchor.constraint(equalTo: labelContainerView.rightAnchor),

            ])
        
        NSLayoutConstraint.activate([
            overlayView.widthAnchor.constraint(equalTo: view.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: view.heightAnchor),
            ])
        
        
        setupReviewViews()

        
    }
    
    
    
    
    private func transactionReviewAddition(number: Int){
        if let employeeUid = employee?.uid{
            let sfReference = db.collection("users").document(employeeUid)
            
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let sfDocument: DocumentSnapshot
                do {
                    try sfDocument = transaction.getDocument(sfReference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let oldReview = sfDocument.data()?["reviewNumber"] as? Int else {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                        ]
                    )
                    errorPointer?.pointee = error
                    return nil
                }
                
                // Note: this could be done without a transaction
                //       by updating the population using FieldValue.increment()
                transaction.updateData(["reviewNumber": oldReview + number], forDocument: sfReference)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction review addition failed: \(error)")
                } else {
                    print("Transaction review addition successfully committed!")
                }
            }
        }
    }
    
    private func transactionThanksAddition(){
        if let employeeUid = employee?.uid{
            let sfReference = db.collection("users").document(employeeUid)
            
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let sfDocument: DocumentSnapshot
                do {
                    try sfDocument = transaction.getDocument(sfReference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let oldThanks = sfDocument.data()?["thanks"] as? Int else {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                        ]
                    )
                    errorPointer?.pointee = error
                    return nil
                }
                
                // Note: this could be done without a transaction
                //       by updating the population using FieldValue.increment()
                transaction.updateData(["thanks": oldThanks + 1], forDocument: sfReference)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction thanks addition failed: \(error)")
                } else {
                    print("Transaction thanks addition successfully committed!")

                }
            }
        }
    }
    
    private func transactionReviewSubstraction(reviewNumberOfCurrentUid: Int){
        if let employeeUid = employee?.uid{
            let sfReference = db.collection("users").document(employeeUid)
            
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let sfDocument: DocumentSnapshot
                do {
                    try sfDocument = transaction.getDocument(sfReference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let oldReviews = sfDocument.data()?["reviewNumber"] as? Int else {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                        ]
                    )
                    errorPointer?.pointee = error
                    return nil
                }
                if oldReviews == 0{
                    return nil
                }
                // Note: this could be done without a transaction
                //       by updating the population using FieldValue.increment()
                transaction.updateData(["reviewNumber": oldReviews - reviewNumberOfCurrentUid], forDocument: sfReference)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction reviews substraction failed: \(error)")
                } else {
                    print("Transaction reviews substraction successfully committed!")
                }
            }
        }
    }
    
    private func transactionThanksSubstraction(){
        if let employeeUid = employee?.uid{
            let sfReference = db.collection("users").document(employeeUid)
            
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let sfDocument: DocumentSnapshot
                do {
                    try sfDocument = transaction.getDocument(sfReference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let oldThanks = sfDocument.data()?["thanks"] as? Int else {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                        ]
                    )
                    errorPointer?.pointee = error
                    return nil
                }
                if oldThanks == 0{
                    return nil
                }
                // Note: this could be done without a transaction
                //       by updating the population using FieldValue.increment()
                transaction.updateData(["thanks": oldThanks - 1], forDocument: sfReference)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction thanks substraction failed: \(error)")
                } else {
                    print("Transaction thanks substraction successfully committed!")
                }
            }
        }
    }
    
}
