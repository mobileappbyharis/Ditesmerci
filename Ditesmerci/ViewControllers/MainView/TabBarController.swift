//
//  NavigationViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 10/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let containerViewController = ContainerViewController()
    var firstName = ""
    var lastName = ""
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem
        setupTab()
        getNames()
        
        self.selectedIndex = 1

    }
    
    func getNames() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        db.collection("users").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            guard let document = documentSnapshot?.data() else {return}
            let user = UserInfo(dictionary: document)
            guard let lastName = user.lastName, let firstName = user.firstName else {return}
            self.lastName = lastName
            self.firstName = firstName
        }
        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let itemSelected = item.title else {return}
        print("selected item : \(itemSelected)")
        switch (itemSelected) {
        case "QRcode":
            //self.navigationController?.popViewController(animated: true)
            break
        case "Radar":
            //self.navigationController?.popViewController(animated: true)
            break
        case "Indicateurs":
            guard let profileViewController = containerViewController.profileViewController else {return}
            let isProfileViewControllerVisible = profileViewController.isProfileViewControllerVisible
            if isProfileViewControllerVisible {
                profileViewController.toggleBurgerMenu()
            }
            break
        default:
            print("problem")
            break
        }
    }
    
    
    
    private func createHomeTabCollectionView(layout: UICollectionViewFlowLayout, title: String, imageName: String) -> UINavigationController {
        let mainViewController = MainViewController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: mainViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.badgeColor = .white
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let image = UIImage(named: imageName)!
        let size = CGSize(width: 23, height: 30)
        let resizedImage = image.resize(targetSize: size)
        navController.tabBarItem.image = resizedImage
        
        return navController
    }
    
    
    
    
    private func createQRCodeTab(viewController: QRCodeViewController, title: String, imageName: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.badgeColor = .white
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let image = UIImage(named: imageName)!
        let size = CGSize(width: 30, height: 30)
        let resizedImage = image.resize(targetSize: size)
        navController.tabBarItem.image = resizedImage

        return navController
    }
    
    private func createProfilTab(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.badgeColor = .white
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let image = UIImage(named: imageName)!
        let size = CGSize(width: 30, height: 30)
        let resizedImage = image.resize(targetSize: size)
        viewController.tabBarItem.image = resizedImage

        return viewController
    }
    
    
    private func setupTab(){
        
        self.viewControllers = [
            self.createQRCodeTab(viewController: QRCodeViewController(), title: "QRcode", imageName: "qrcode"),
            self.createHomeTabCollectionView(layout: UICollectionViewFlowLayout(), title: "Radar", imageName: "accueilbutton"),
            self.createProfilTab(viewController: containerViewController, title: "Indicateurs", imageName: "profilbutton")
            //  self.createQRCodeTab(viewController: MapGeofireViewController(), title: "Map", imageName: "settings"),
            
        ]
        
    }
    
}
