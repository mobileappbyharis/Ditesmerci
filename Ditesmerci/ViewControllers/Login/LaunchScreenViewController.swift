//
//  SplashScreen.swift
//  Ditesmerci
//
//  Created by 7k04 on 10/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class LaunchScreenViewController: UIViewController {
    var alertController: UIAlertController?
    
    var db: Firestore!
    var auth: Auth!
    var handle: AuthStateDidChangeListenerHandle?
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-v1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "VERSION 1.0"
        label.textColor = .blueMerci
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let wifiProblemTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Problème réseau. La connexion internet semble interrompue. Veuillez réessayer."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .red
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()
    
    private func setupFirebase(){
        self.db = Firestore.firestore()
        self.auth = Auth.auth()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        settings.isPersistenceEnabled = false
        db.settings = settings
    }
    
    
    func logout(){
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Setup
        setupFirebase()
        setupViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if(self.isConnectedToInternet()){
                self.handle = self.auth.addStateDidChangeListener { (auth, user) in
                    print(user)
                    if user != nil {
                        // User is signed in.
                        print("user is signed in")
                        let uid = user?.uid
                        print("user : \(String(describing: uid))")
                        
                        self.db.collection("users").document(uid!).getDocument { (document, error) in
                            if let document = document, document.exists {
                                //User hava data in firestore
                                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                                print("Document data: \(dataDescription)")
                                let payoutViewController = PayoutViewController()
                                payoutViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                                let tabBarController = TabBarController()
                                tabBarController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                                self.present(tabBarController, animated: false, completion: nil)
                                auth.removeStateDidChangeListener(self.handle!)
                                
                            } else {
                                //User don't have data in firestore
                                print("Document does not exist")
                                let showCaseViewController = ShowcaseViewController()
                                showCaseViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

//                                let nav = UINavigationController(rootViewController: showCaseViewController)
                                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                                self.navigationController?.pushViewController(showCaseViewController, animated: false)

//                                self.present(nav, animated: false, completion: nil)
                                auth.removeStateDidChangeListener(self.handle!)
                                
                            }
                        }
                    } else {
                        // No user is signed in.
                        print("user not signed in")
                        let showCaseViewController = ShowcaseViewController()
                        showCaseViewController.modalPresentationStyle = .fullScreen
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.navigationController?.pushViewController(showCaseViewController, animated: false)
                        auth.removeStateDidChangeListener(self.handle!)
                        
                    }
                }
                
            } else {
                print("no internet connexion")
                self.setupConnexionProblemView()
                
            }
            
        }
        
    }
    
    
    private func setupViews(){
        setupNormalViews()
    }
    
    private func setupNormalViews(){
        view.addSubview(logoImageView)
        view.addSubview(versionLabel)
        
        
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
            ])
        
        
        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            versionLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    private func setupConnexionProblemView(){
        view.addSubview(wifiProblemTextView)
        self.addConstraintFromView(subview: wifiProblemTextView, attribute: .centerY, multiplier: 1.6, identifier: "wifiProblemTextView placement Y")
        NSLayoutConstraint.activate([
            wifiProblemTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wifiProblemTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            wifiProblemTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
    }
}



