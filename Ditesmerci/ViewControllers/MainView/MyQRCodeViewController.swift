//
//  MyQRCodeViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 07/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDynamicLinks

class MyQRCodeViewController: UIViewController {
    // For DynamicLinks
    let domainURIPrefix = "https://ditesmerci.page.link"
    let scheme = "https"
    let host = "www.ditesmerci.com"
    let path = "/profil"
    let ditesMerciImage = "https://firebasestorage.googleapis.com/v0/b/ditesmerci-c006a.appspot.com/o/test%2Flogo%20dites%20merci.jpg?alt=media&token=6ea0e4b5-7ba6-4f62-ab87-9745265fe895"
    // Firestore & Auth
    var auth = Auth.auth()
    var db = Firestore.firestore()
    var listener: ListenerRegistration?

    
    let topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        

        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        
        return label
    }()
    
    let addressTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.textColor = .black
        textView.isSelectable = false
        textView.isEditable = false
        return textView
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        fetchProfileDataIRT()
        generateQRCode()
    }
    
    private func createShareProfilLink(){
        print("try to create share profil link")
        guard let uid = auth.currentUser?.uid else {return}
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        let uidQueryItem = URLQueryItem(name: "uid", value: uid)
        components.queryItems = [uidQueryItem]
        
        guard let linkParameter = components.url else {return}
        
        print("I am sharing \(linkParameter.absoluteString)")
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: domainURIPrefix) else {
            print("couldn't create FDL components")
            return
        }
        if let myBundleId = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        // Temporarily use Google Photos
        shareLink.iOSParameters?.appStoreID = "962194608"
        
        let imageUrl = URL(fileURLWithPath: ditesMerciImage)

        // To have something more fancy than just lead to the appstore
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Dites merci!"
        shareLink.socialMetaTagParameters?.descriptionText = "Un utilisateur de 'Dites Merci' a voulu vous partager son profil. Remerciez le en cliquant sur 'open'."
        shareLink.socialMetaTagParameters?.imageURL = imageUrl
        
        
        guard let longURL = shareLink.url else {return}
        print("the long dynamic link is \(longURL)")
        let alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController)
        shareLink.shorten { [weak self] (url, warnings, error) in
            if let error = error {
                print("Got an error with dynamic link! \(error)")
                return
            }
            if let warnings = warnings {
                for warning in warnings {
                    print("FDL Warning : \(warning)")
                }
            }
            guard let url = url else {return}
            print("Short url to share : \(url.absoluteString)")
            //self?.generateQRCode(link: url.absoluteString, alertController: alertController)
        }

    }
    
    private func generateQRCode(){
        print("try to generate QRCode")
        guard let uid = auth.currentUser?.uid else {return}
        let myString = uid
        let data = myString.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        //let processedImage = UIImage(cgImage: cgImage)
        
        qrCodeImageView.image = UIImage(cgImage: cgImage)
    }
    
    private func generateQRCodec(link: String, alertController : UIAlertController){
        print("try to generate QRCode")
        let myString = link
        let data = myString.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        //let processedImage = UIImage(cgImage: cgImage)
        
        qrCodeImageView.image = UIImage(cgImage: cgImage)
        alertController.dismiss(animated: true, completion: nil)
    }
    
    // IRT = In Real Time
    private func fetchProfileDataIRT(){
        print("try to fetch in real time profile data to firestore")
        if let uid = auth.currentUser?.uid {
            listener = db.collection("users").document(uid).addSnapshotListener { (documentSnapshot, error) in
                if let error = error {
                    print("failed to fetch IRT document: \(error)")
                    return
                }
                guard let document = documentSnapshot?.data() else {
                    return
                }
                
                let userInfo = UserInfo(dictionary: document)
                if let firstName = userInfo.firstName, let lastName = userInfo.lastName, let isPro = userInfo.isPro {
                    self.nameLabel.text = firstName + " " + lastName
                    if isPro {
                        if let job = userInfo.job, let jobFormattedAddress = userInfo.jobFormattedAddress {
                            self.jobLabel.text =  job.capitalizingFirstLetter()
                            self.addressTextView.text = jobFormattedAddress
                        }
                    }
                }
                if let profileImageUrlThumbnail = userInfo.profileImageUrlThumbnail {
                    if profileImageUrlThumbnail != "none" {
                        self.displayProfileImage(profileImageUrlThumbnail: profileImageUrlThumbnail)
                    }
                }
            }
        }
    }
    
    private func displayProfileImage(profileImageUrlThumbnail: String) {
        let url = URL(string: profileImageUrlThumbnail)
        let placeHolder = UIImage(named: "user")
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    private func setupViews(){
        print("setup profile views")
        view.addSubview(topContainerView)
        view.addSubview(qrCodeImageView)
        topContainerView.addSubview(profileImageView)
        topContainerView.addSubview(labelContainerView)
        
        labelContainerView.addSubview(nameLabel)
        labelContainerView.addSubview(jobLabel)
        labelContainerView.addSubview(addressTextView)
        
        self.addConstraintFromView(subview: qrCodeImageView, attribute: .centerY, multiplier: 1.25, identifier: "qrCodeView placement Y")
        NSLayoutConstraint.activate([
            qrCodeImageView.heightAnchor.constraint(equalToConstant: 200),
            qrCodeImageView.widthAnchor.constraint(equalToConstant: 200),
            qrCodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            topContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),
            profileImageView.leftAnchor.constraint(equalTo: topContainerView.leftAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
            ])
        
        NSLayoutConstraint.activate([
            labelContainerView.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),
            labelContainerView.rightAnchor.constraint(equalTo: topContainerView.rightAnchor),
            labelContainerView.widthAnchor.constraint(equalTo: topContainerView.widthAnchor, multiplier: 0.5),
            labelContainerView.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.52),
            ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: labelContainerView.leftAnchor),
            nameLabel.heightAnchor.constraint(equalTo: labelContainerView.heightAnchor, multiplier: 0.30),
            ])
        
        NSLayoutConstraint.activate([
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            jobLabel.leftAnchor.constraint(equalTo: labelContainerView.leftAnchor),
            jobLabel.heightAnchor.constraint(equalTo: labelContainerView.heightAnchor, multiplier: 0.30),
            ])
        
        NSLayoutConstraint.activate([
            addressTextView.topAnchor.constraint(equalTo: jobLabel.bottomAnchor),
            addressTextView.leftAnchor.constraint(equalTo: labelContainerView.leftAnchor),
            addressTextView.rightAnchor.constraint(equalTo: labelContainerView.rightAnchor),
            addressTextView.heightAnchor.constraint(equalTo: labelContainerView.heightAnchor, multiplier: 0.70),
            ])
    }
}
