//
//  CreditCardListViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 16/02/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFunctions
import FirebaseAuth
import Kingfisher


class CreditCardListViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profileViewController: ProfileViewController?

    var db = Firestore.firestore()
    var auth = Auth.auth()
    var profileImageUrl = "none"
    var firstName = ""
    var lastName = ""
    
    var cardList = [CardModel]()

    private let firstBankCardCellId = "firstBankCardCellId"
    private let bankCardCellId = "bankCardCellId"
    private let lastBankCardCellId = "lastBankCardCellId"
    lazy var functions = Functions.functions(region: "europe-west1")
    var defaultCard: CardModel?
    var positionDefaultCard = 0
    var alertController: UIAlertController?

    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blueMerci
        refreshControl.attributedTitle = NSAttributedString(string: "Chargement des données...")
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchCreditCardData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()
        
        // CollectionView
        collectionView.backgroundColor = UIColor.clear

        collectionView.register(FirstBankCardCell.self, forCellWithReuseIdentifier: firstBankCardCellId)
        collectionView.register(BankCardCell.self, forCellWithReuseIdentifier: bankCardCellId)
        collectionView.register(LastBankCardCell.self, forCellWithReuseIdentifier: lastBankCardCellId)


        collectionView.refreshControl = refreshControl
        fetchUserData()
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCreditCardData()
    }
    
     private func fetchCreditCardData(){
        print("trying to fetch credit card data")
        removeCreditCardData()
        
        guard let uid = auth.currentUser?.uid else {return}
        // payment_methods
        self.db.collection("mangopay_customers").document(uid).collection("cards").whereField("Active", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("failed to get reviews: \(error)")
                return
            }
            guard let documents = querySnapshot?.documents else {return}
            var i = 0
            for document in documents {
                i = i + 1
                let cardModel = CardModel(dictionary: document.data())
                
                if cardModel.isDefault ?? false {
                    self.defaultCard = cardModel
                    self.positionDefaultCard = i
                }
                self.cardList.append(cardModel)
            }
            
            // for first item which is not a card model
            let firstFakeCardCell = CardModel(dictionary:[
                "id": "fake1"
                ] as [AnyHashable : Any])
            self.cardList.insert(firstFakeCardCell, at: 0) // For the first cell

            
            // for last item which is not a card model
            let lastFakeCardCell = CardModel(dictionary:[
                "id": "fake2"
                ] as [AnyHashable : Any])
            self.cardList.append(lastFakeCardCell) // For the Add a card button
            
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
            })
    }
}
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstBankCardCellId, for: indexPath) as! FirstBankCardCell
            
            cell.nameLabel.text = firstName + " " + lastName

            if self.profileImageUrl != "none" {
                let url = URL(string: self.profileImageUrl)
                let placeHolder = UIImage(named: "user")
                cell.profileImageView.kf.indicatorType = .activity
                cell.profileImageView.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            return cell
        } else if indexPath.item == cardList.count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: lastBankCardCellId, for: indexPath) as! LastBankCardCell
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bankCardCellId, for: indexPath) as! BankCardCell
        let position = indexPath.item
        let card = cardList[position]
        
        if card.isDefault ?? false {
            cell.verifyImageView.alpha = 1.0
        } else {
            cell.verifyImageView.alpha = 0.3
        }
        
        cell.cardNumberLabel.text = card.alias
        
        
        cell.position = position
        cell.creditCardListViewController = self
        
        return cell
        
    }
    
    
    
    
    func changeDefaultCard(position: Int) {
        guard let uid = auth.currentUser?.uid else {return}
        if position == positionDefaultCard {
            return
        }
        if positionDefaultCard != 0 {
            db.collection("mangopay_customers").document(uid).collection("cards").document((defaultCard?.id)!).setData(["isDefault" : false], merge: true) { (error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    return
                }
                self.cardList[self.positionDefaultCard].isDefault = false
                self.db.collection("mangopay_customers").document(uid).collection("cards").document(self.cardList[position].id!).setData(["isDefault" : true], merge: true) { (error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                    self.positionDefaultCard = position
                    self.defaultCard = self.cardList[position]
                    self.cardList[position].isDefault = true
                    DispatchQueue.main.async(execute: {
                        self.collectionView.reloadData()
                    })
                }
                
            }
        } else {
            db.collection("mangopay_customers").document(uid).collection("cards").document(cardList[position].id!).setData(["isDefault" : true], merge: true) { (error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    return
                }
                self.positionDefaultCard = position
                self.defaultCard = self.cardList[position]
                self.cardList[position].isDefault = true
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                })
            }
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let lastItemIndex = cardList.count - 1
        
        if index == lastItemIndex {
            // Add a credit card
            DispatchQueue.main.async {
                let addCreditCardViewController = AddCreditCardViewController()
                addCreditCardViewController.name = self.firstName + " " + self.lastName
                addCreditCardViewController.profileImageUrl = self.profileImageUrl
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(addCreditCardViewController, animated: true)
            }
        } else if index > 0 && index < lastItemIndex {
            // View Info credit card
            DispatchQueue.main.async {
                let modifyCreditCardVC = ModifyCreditCardVC()
                modifyCreditCardVC.name = self.firstName + " " + self.lastName
                modifyCreditCardVC.profileImageUrl = self.profileImageUrl
                modifyCreditCardVC.card = self.cardList[index]

                // Add the credit card information
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(modifyCreditCardVC, animated: true)
            }
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = cardList.count
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let size: CGSize = CGSize(width: collectionView.frame.width, height: 210)
            return size
        }
        
        let size: CGSize = CGSize(width: collectionView.frame.width - 30, height: 60)
        return size
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileViewController?.boolBurger = true
    }
    
    
    private func removeCreditCardData(){
        print("trying to remove credit card data")
        cardList.removeAll()
        collectionView.reloadData()
    }
    
    private func fetchUserData(){
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("users").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("failed to get info user: \(error)")
                return
            }
            
            guard let document = documentSnapshot?.data() else {return}
            
            let userInfo = UserInfo(dictionary: document)
            
            if let firstName = userInfo.firstName, let lastName = userInfo.lastName {
                self.firstName = firstName
                self.lastName = lastName
            }
            
            if let profileImageUrl = userInfo.profileImageUrl {
                self.profileImageUrl = profileImageUrl
            }
            
        }
    }
    
    
    
}
