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

class ProViewController : UIViewController {
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var profileImageUrl = "none"
    var listener: ListenerRegistration?
    var placeID = "none"

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
        label.textColor = .white
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        
        return label
    }()
    
    let jobAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        return label
    }()
    
    let jobSectorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.backgroundColor = .blueMerci
        label.textAlignment = .center
        return label
    }()
    
    lazy var modifiedImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "cadenas")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModified)))
        
        return imageView
    }()
    
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
    
    
    
    @objc private func handleModified(){
        print("try to modified")
        DispatchQueue.main.async {
            let proModifiedViewController = ProModifiedViewController()
            if self.profileImageUrl != "none" {
                proModifiedViewController.profileImageUrl = self.profileImageUrl
            }
            if self.placeID != "none" {
                proModifiedViewController.oldPlaceID = self.placeID
            }
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(proModifiedViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        view.backgroundColor = .white
        setupViews()
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
                self.placeID = placeID
                self.profileImageUrl = profileImageUrlThumbnail
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
