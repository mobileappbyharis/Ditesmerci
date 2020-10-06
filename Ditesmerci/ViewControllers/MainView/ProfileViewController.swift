//
//  ProfileViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 12/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class ProfileViewController: UIViewController {
    var auth = Auth.auth()
    var db = Firestore.firestore()
    //lazy var functions = Functions.functions()
    var user: User?
    var delegate: ProfileViewControllerDelegate?
    
    var email = "none"
    var job = "none"
    var phoneNumber = "none"
    var birthdate = "none"
    var formattingAddress = "none"
    var isPro = false
    var isProfileViewControllerVisible = true
    var firstName = "none"
    var lastName = "none"
    var profileImageUrl = "none"
    var listener: ListenerRegistration?
    var tap: UITapGestureRecognizer?
    var boolBurger = false // définir ce qu'il veut dire
    var isBurgerVisible = false
    lazy var functions = Functions.functions(region: "europe-west1")
    // For DynamicLinks
    let domainURIPrefix = "https://ditesmerci.page.link"
    let scheme = "https"
    let host = "www.ditesmerci.com"
    let path = "/invite"
    let ditesMerciImage = "https://firebasestorage.googleapis.com/v0/b/ditesmerci-c006a.appspot.com/o/test%2Flogo%20dites%20merci.jpg?alt=media&token=6ea0e4b5-7ba6-4f62-ab87-9745265fe895"
    let MPbaseUrl = "https://api.sandbox.mangopay.com"
    let MPclientID = "ditesmerci"
    let MPclientApiKey = "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU"
    let authorizationHeader = "Basic \(("ditesmerci" + ":" + "qXJZ4XPruznKo3RveZRhHfNxraE6E2Ugby9VXTHW9Tjzp317SU").data(using: .utf8)!.base64EncodedString())"

    lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ditesmerci")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let middleContainerView: UIView = {
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
    
    lazy var merciImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mythanks")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let thanksNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    
    lazy var reviewsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myreviews")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHistoricView)))
        return imageView
    }()
    
    let reviewsNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .yellowMerci
        return label
    }()
    
    
    lazy var pourboireImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mypourboires")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAmountPouboire)))
        return imageView
    }()
    
    let pourboireLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .purpleMerci
        return label
    }()
    
    lazy var burgerMenuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "burger")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBurgerView)))
        return imageView
    }()
    
    lazy var inviteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "invitation")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInvite)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isHidden = true
        return view
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let contactUsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Contactez-nous"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let byPhoneNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  PAR TÉLEPHONE  ", for: .normal)
        button.addTarget(self, action: #selector(handleByPhoneNumber), for: .touchUpInside)
        button.backgroundColor = .blueMerci
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    
    let byEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  PAR E-MAIL  ", for: .normal)
        button.addTarget(self, action: #selector(handleByEmail), for: .touchUpInside)
        button.backgroundColor = .blueMerci
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    @objc private func handleAmountPouboire() {
        print("trying to open payout view")
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(PayoutViewController(), animated: true)
            //self.delegate?.toggleRightPanel(firstName: self.firstName, lastName: self.lastName)
        }
    }
    
    @objc private func handleInvite(){
        print("trying to open external apps")
        setupDynamicLink()
    }
    
    private func setupDynamicLink(){
        print("try to create share profil link")
        let alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController)
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
        shareLink.socialMetaTagParameters?.title = "Soyez récompensé pour votre travail!"
        shareLink.socialMetaTagParameters?.descriptionText = "Un client a voulu vous remercier sur la plateforme 'Dites Merci'. Téléchargez l'application afin de recevoir son avis."
        shareLink.socialMetaTagParameters?.imageURL = imageUrl
        
        
        guard let longURL = shareLink.url else {return}
        print("the long dynamic link is \(longURL)")
        
        
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
            let textToShare = "Un client est très satisfait de votre prestation et souhaite vous remercier. Cliquez sur le lien suivant afin de recevoir son avis."
            
            let objectsToShare: [Any] = [textToShare, url]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            alertController.dismiss(animated: true, completion: {
                self?.present(activityVC, animated: true, completion: nil)
            })
            
        }
    }

    @objc private func handleByPhoneNumber(){
        print("try to contact by phone number")

    }
    
    @objc private func handleByEmail(){
        print("try to contact by email")
        
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
                    DispatchQueue.main.async {
                      self.pourboireLabel.text = "\(balance/100) €"
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
        }
        
    }
    
    @objc private func handleMyQRCode(){
        print("try to display MyQRCodeViewController")
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(MyQRCodeViewController(), animated: true)
        }
        
    }
    
    @objc private func handleHistoricView(){
        print("try to display HistoricView")
        if isBurgerVisible {return}
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(HistoricViewController(), animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isProfileViewControllerVisible = false
        listener?.remove()
        if tap != nil {
            view.removeGestureRecognizer(tap!)
        }
        delegate?.disableGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isProfileViewControllerVisible = true
        super.viewWillAppear(animated)
        getWalletBalanceRequest()
//        if boolBurger {
//            toggleBurgerMenu()
//            boolBurger = false
//        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        isProfileViewControllerVisible = true
        super.viewDidAppear(animated)
        fetchProfileDataIRT()
        tapToHideReviewView()
        //delegate?.enableGesture()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        user = auth.currentUser
        setupViews()
        setupNavigationBar()
        setupBackButton()
        delegate?.disableGesture()
        
    }
    
    // MARK: NavigationBar system
    func setupNavigationBar(){
        if let navControllerView = navigationController?.view {
            navControllerView.backgroundColor = .white
            navigationItem.titleView = bannerImageView
            if let bannerImage = bannerImageView.image {
                bannerImageView.image = bannerImage.resize(targetSize: CGSize(width: 150, height: 33))
            }
            
            if let burgerImage = burgerMenuImageView.image {
                burgerMenuImageView.image = burgerImage.resize(targetSize: CGSize(width: 30, height: 30))
                let barBurgerButton = UIBarButtonItem(customView: burgerMenuImageView)
                self.navigationItem.rightBarButtonItem = barBurgerButton
            }
            
            if let inviteImage = inviteImageView.image {
                inviteImageView.image = inviteImage.resize(targetSize: CGSize(width: 30, height: 30))
                let barQrcodeButton = UIBarButtonItem(customView: inviteImageView)
                self.navigationItem.leftBarButtonItem = barQrcodeButton
            }
        }
    }
    
    @objc private func handleQRCode(){
        print("try to handleQRCode")
        
    }
    

    
    @objc private func handleBurgerView(){
        print("try to burgerView")
        toggleBurgerMenu()
    }
    
    
    // IRT = In Real Time
    private func fetchProfileDataIRT(){
        print("try to fetch in real time profile data to firestore")
        if let uid = user?.uid {
        listener = db.collection("users").document(uid).addSnapshotListener { (documentSnapshot, error) in
                if let error = error {
                    print("failed to fetch IRT document: \(error)")
                    return
                }
                guard let document = documentSnapshot?.data() else {return}
                
                let userInfo = UserInfo(dictionary: document)
                self.firstName = userInfo.firstName ?? "none"
                self.email = userInfo.email ?? "none"
                self.lastName = userInfo.lastName ?? "none"
                self.birthdate = userInfo.birthdate ?? "none"
                self.formattingAddress = userInfo.jobFormattedAddress ?? "none"
                self.phoneNumber = userInfo.phoneNumber ?? "none"
                self.job = userInfo.job ?? "none"
                self.isPro = userInfo.isPro ?? false
                self.delegate?.giveName(firstName: self.firstName, lastName: self.lastName)
                let job = userInfo.job ?? ""
                let formattedAddress = userInfo.jobFormattedAddress ?? ""
                if let profileImageUrlThumbnail = userInfo.profileImageUrlThumbnail {
                    self.profileImageUrl = profileImageUrlThumbnail
                    if profileImageUrlThumbnail != "none" {
                        self.displayProfileImage(profileImageUrlThumbnail: profileImageUrlThumbnail)
                    }
                }
                let thanksNumber = userInfo.thanks
                let reviewNumber = userInfo.reviewNumber
                self.nameLabel.text = self.firstName + " " + self.lastName
                self.jobLabel.text =  job.capitalizingFirstLetter()
                self.addressTextView.text = formattedAddress
                self.thanksNumberLabel.text = thanksNumber?.description
                self.reviewsNumberLabel.text = reviewNumber?.description
            }
        }
    }
    
    private func handleLogout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let showCaseViewController = ShowcaseViewController()
            showCaseViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            let nav = UINavigationController(rootViewController: showCaseViewController)
            nav.modalPresentationStyle = .fullScreen
            nav.interactivePopGestureRecognizer?.isEnabled = true
            nav.setNavigationBarHidden(true, animated: false)
            self.present(nav, animated: false, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
        view.addSubview(middleContainerView)
        topContainerView.addSubview(profileImageView)
        topContainerView.addSubview(labelContainerView)
        
        labelContainerView.addSubview(nameLabel)
        labelContainerView.addSubview(jobLabel)
        labelContainerView.addSubview(addressTextView)
        
        middleContainerView.addSubview(merciImageView)
        middleContainerView.addSubview(reviewsImageView)
        middleContainerView.addSubview(pourboireImageView)

        
        
        merciImageView.addSubview(thanksNumberLabel)
        reviewsImageView.addSubview(reviewsNumberLabel)
        pourboireImageView.addSubview(pourboireLabel)
        merciImageView.bringSubviewToFront(thanksNumberLabel)
        reviewsImageView.bringSubviewToFront(reviewsNumberLabel)
        pourboireImageView.bringSubviewToFront(pourboireLabel)


        NSLayoutConstraint.activate([
            thanksNumberLabel.bottomAnchor.constraint(equalTo: merciImageView.bottomAnchor, constant: -20),
            thanksNumberLabel.rightAnchor.constraint(equalTo: merciImageView.rightAnchor, constant: -15),
            ])
        
        NSLayoutConstraint.activate([
            reviewsNumberLabel.bottomAnchor.constraint(equalTo: reviewsImageView.bottomAnchor, constant: -20),
            reviewsNumberLabel.rightAnchor.constraint(equalTo: reviewsImageView.rightAnchor, constant: -15),
            ])
        
        NSLayoutConstraint.activate([
            pourboireLabel.bottomAnchor.constraint(equalTo: pourboireImageView.bottomAnchor, constant: -20),
            pourboireLabel.rightAnchor.constraint(equalTo: pourboireImageView.rightAnchor, constant: -15),
            ])

        
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            topContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
            ])

        NSLayoutConstraint.activate([
            middleContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            middleContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            middleContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            middleContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.89)
            ])
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),
            profileImageView.leftAnchor.constraint(equalTo: topContainerView.leftAnchor),
            profileImageView.widthAnchor.constraint(equalTo: topContainerView.widthAnchor, multiplier: 0.45),
            profileImageView.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.76)
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
        
        NSLayoutConstraint.activate([
            merciImageView.topAnchor.constraint(equalTo: middleContainerView.topAnchor),
            merciImageView.leftAnchor.constraint(equalTo: middleContainerView.leftAnchor),
            merciImageView.heightAnchor.constraint(equalTo: middleContainerView.heightAnchor, multiplier: 0.49),
            merciImageView.widthAnchor.constraint(equalTo: middleContainerView.widthAnchor, multiplier: 0.47),
            ])
        
        NSLayoutConstraint.activate([
            reviewsImageView.topAnchor.constraint(equalTo: middleContainerView.topAnchor),
            reviewsImageView.rightAnchor.constraint(equalTo: middleContainerView.rightAnchor),
            reviewsImageView.heightAnchor.constraint(equalTo: middleContainerView.heightAnchor, multiplier: 0.49),
            reviewsImageView.widthAnchor.constraint(equalTo: middleContainerView.widthAnchor, multiplier: 0.47),
            ])
        
        NSLayoutConstraint.activate([
            pourboireImageView.centerXAnchor.constraint(equalTo: merciImageView.centerXAnchor),
            pourboireImageView.topAnchor.constraint(equalTo: merciImageView.bottomAnchor),
            pourboireImageView.heightAnchor.constraint(equalTo: middleContainerView.heightAnchor, multiplier: 0.49),
            pourboireImageView.widthAnchor.constraint(equalTo: middleContainerView.widthAnchor, multiplier: 0.47),
            ])
        
        
        setupContactUsView()
    }
    
    
    private func setupContactUsView(){
        view.addSubview(overlayView)
        overlayView.addSubview(whiteView)
        whiteView.addSubview(contactUsLabel)
        whiteView.addSubview(byPhoneNumberButton)
        whiteView.addSubview(byEmailButton)
        
        
        NSLayoutConstraint.activate([
            overlayView.widthAnchor.constraint(equalTo: view.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: view.heightAnchor),
            ])
        
        NSLayoutConstraint.activate([
            whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            whiteView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
            whiteView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            ])
        
        NSLayoutConstraint.activate([
            contactUsLabel.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            contactUsLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 20),
            ])
        
        NSLayoutConstraint.activate([
            byPhoneNumberButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            byPhoneNumberButton.bottomAnchor.constraint(equalTo: byEmailButton.topAnchor, constant: -10),
            byPhoneNumberButton.widthAnchor.constraint(equalTo: whiteView.widthAnchor, constant: -20),
            byPhoneNumberButton.heightAnchor.constraint(equalTo: whiteView.heightAnchor, multiplier: 0.25),
            ])
        
        NSLayoutConstraint.activate([
            byEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            byEmailButton.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -10),
            byEmailButton.widthAnchor.constraint(equalTo: whiteView.widthAnchor, constant: -20),
            byEmailButton.heightAnchor.constraint(equalTo: whiteView.heightAnchor, multiplier: 0.25),
            ])
        


    }
    @objc private func hideReviewView(){
        overlayView.isHidden = true
        if tap != nil {
            view.removeGestureRecognizer(tap!)
        }
        
    }
    private func tapToHideReviewView() {
        tap = UITapGestureRecognizer(target: self, action: #selector(hideReviewView))
        tap!.cancelsTouchesInView = false
        view.addGestureRecognizer(tap!)
    }
    
    func toggleBurgerMenu() {
        self.isBurgerVisible.toggle()
        self.delegate?.toggleRightPanel(firstName: self.firstName, lastName: self.lastName)
    }
    
}




extension ProfileViewController: SidePanelViewControllerDelegate {
    func didSelectItemPanel(_ itemPanel: ItemPanelModel) {
        let title = itemPanel.title

        switch title {
        case "IDENTITÉ":
            let modifiedIdentityViewController = ModifiedIdentityViewController()
            modifiedIdentityViewController.profileViewController = self
            toggleBurgerMenu()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(modifiedIdentityViewController, animated: true)
            }
            break
            
        case "FICHE PROFESSIONNELLE":
            let proModifiedViewController = ProModifiedViewController()
            proModifiedViewController.profileViewController = self
            toggleBurgerMenu()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(proModifiedViewController, animated: true)
            }
            break
            
        case "INFORMATIONS FINANCIÈRES":
            let creditCardListViewController = CreditCardListViewController(collectionViewLayout: UICollectionViewFlowLayout())
            creditCardListViewController.profileViewController = self
            toggleBurgerMenu()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(creditCardListViewController, animated: true)
            }
            break
            
        case "Carte(s) bancaire(s)":
            let creditCardListViewController = CreditCardListViewController(collectionViewLayout: UICollectionViewFlowLayout())
            creditCardListViewController.profileViewController = self
            toggleBurgerMenu()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(creditCardListViewController, animated: true)
            }
            break
        case "Compte(s) bancaire(s)":
            if isPro {
                let bankAccountListViewController = BankAccountListViewController(collectionViewLayout: UICollectionViewFlowLayout())
                bankAccountListViewController.profileViewController = self
                toggleBurgerMenu()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                    self.navigationController?.pushViewController(bankAccountListViewController, animated: true)
                }
            } else {
                print("Not pro")
                self.displayAlertErrorUI(title: "Erreur", message: "Pour accéder à cette rubrique, veuillez rentrer vos informations professionnelles dans la rubrique 'Fiche Professionelle'", answer: "OK")
            }
            break
            
        case "Vérification d'identité":
            let identityVerification = IdentityVerification()
            identityVerification.profileViewController = self
            identityVerification.firstName = self.firstName
            identityVerification.lastName = self.lastName
            
            toggleBurgerMenu()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(identityVerification, animated: true)
            }
            
            break
            
        case "HISTORIQUE FINANCIER":
        if isPro {
            let fiancialHistoric = FinancialHistoric(collectionViewLayout: UICollectionViewFlowLayout())
            fiancialHistoric.profileViewController = self

            fiancialHistoric.profileImageUrl = profileImageUrl
            fiancialHistoric.firstName = self.firstName
            fiancialHistoric.lastName = self.lastName
            toggleBurgerMenu()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(fiancialHistoric, animated: true)
            }
        } else {
            print("Not pro")
            self.displayAlertErrorUI(title: "Erreur", message: "Pour accéder à cette rubrique, veuillez rentrer vos informations professionnelles dans la rubrique 'Fiche Professionelle'", answer: "OK")
        }
        break
            
        case "HISTORIQUE PROFESSIONNEL":
            if isPro {
                let historicProViewController = HistoricProViewController(collectionViewLayout: UICollectionViewFlowLayout())
                historicProViewController.profileViewController = self

                historicProViewController.profileImageUrl = profileImageUrl
                historicProViewController.firstName = self.firstName
                historicProViewController.lastName = self.lastName
                toggleBurgerMenu()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                    self.navigationController?.pushViewController(historicProViewController, animated: true)
                }
            } else {
                print("Not pro")
                self.displayAlertErrorUI(title: "Erreur", message: "Pour accéder à cette rubrique, veuillez rentrer vos informations professionnelles dans la rubrique 'Fiche Professionelle'", answer: "OK")
            }
            break
            
        case "ASSISTANCE":
            overlayView.isHidden = false
            tapToHideReviewView()
            view.bringSubviewToFront(overlayView)
            toggleBurgerMenu()

            break
            
        case "INFORMATIONS":
            let creditViewController = CreditViewController()
            creditViewController.profileViewController = self
            toggleBurgerMenu()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(creditViewController, animated: true)
            }
            break
            
        case "DÉCONNEXION":
            handleLogout()
            break
            
        default:
            print("error")
            break
        }
    }
}

protocol ProfileViewControllerDelegate {
    func toggleRightPanel(firstName: String, lastName: String)
    func collapseSidePanels()
    func enableGesture()
    func disableGesture()
    func giveName(firstName: String, lastName: String)

}
