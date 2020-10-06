//
//  BankAccountListViewController.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 01/06/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

class BankAccountListViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var profileViewController: ProfileViewController?

    var db = Firestore.firestore()
    var auth = Auth.auth()
    var profileImageUrl = "none"
    var firstName = ""
    var lastName = ""
    
    var defaultBankAccount: BankAccountModel?
    var positionDefaultBankAccount = 0
    
    var bankAccountList = [BankAccountModel]()
    
    private let firstBankAccountCellId = "firstBankAccountCellId"
    private let bankAccountCellId = "bankAccountCellId"
    private let lastBankAccountCellId = "lastBankAccountCellId"
    var defaultBankAccountId: String?
    var alertController: UIAlertController?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blueMerci
        refreshControl.attributedTitle = NSAttributedString(string: "Chargement des données...")
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchBankAccountData()
        self.refreshControl.endRefreshing()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileViewController?.boolBurger = true
    }
    
    private func removeBankAccountData(){
        print("trying to remove credit card data")
        bankAccountList.removeAll()
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = bankAccountList.count
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
    
    func fetchBankAccountData() {
        removeBankAccountData()
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("mangopay_customers").document(uid).collection("bank_accounts").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {return}
            
            var i = 0
            for document in documents {
                i = i + 1
                let bankAccountModel = BankAccountModel(dictionary: document.data())
                
                if bankAccountModel.isDefault ?? false {
                    self.defaultBankAccount = bankAccountModel
                    self.positionDefaultBankAccount = i
                }
                self.bankAccountList.append(bankAccountModel)
            }
            
            // for first item which is not a card model
            let firstBankAccountCell = BankAccountModel(dictionary:[
                "id": "fake1"
                ] as [AnyHashable : Any])
            self.bankAccountList.insert(firstBankAccountCell, at: 0) // For the first cell

            
            // for last item which is not a card model
            let lastBankAccountCell = BankAccountModel(dictionary:[
                "id": "fake2"
                ] as [AnyHashable : Any])
            self.bankAccountList.append(lastBankAccountCell) // For the Add a card button
            
            self.reloadList()
        }
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // CollectionView
        collectionView.backgroundColor = UIColor.clear

        collectionView.register(FirstBankAccountCell.self, forCellWithReuseIdentifier: firstBankAccountCellId)
        collectionView.register(BankAccountCell.self, forCellWithReuseIdentifier: bankAccountCellId)
        collectionView.register(LastBankAccountCell.self, forCellWithReuseIdentifier: lastBankAccountCellId)


        collectionView.refreshControl = refreshControl
        fetchUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           fetchBankAccountData()
       }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstBankAccountCellId, for: indexPath) as! FirstBankAccountCell
            
            cell.nameLabel.text = firstName + " " + lastName

            if self.profileImageUrl != "none" {
                let url = URL(string: self.profileImageUrl)
                let placeHolder = UIImage(named: "user")
                cell.profileImageView.kf.indicatorType = .activity
                cell.profileImageView.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            return cell
        } else if indexPath.item == bankAccountList.count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: lastBankAccountCellId, for: indexPath) as! LastBankAccountCell
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bankAccountCellId, for: indexPath) as! BankAccountCell
        let position = indexPath.item
        let bankAccount = bankAccountList[position]
        
        if bankAccount.isDefault ?? false {
            cell.verifyImageView.alpha = 1.0
        } else {
            cell.verifyImageView.alpha = 0.3
        }
        
        if let iban = bankAccount.iban {
            cell.bankAccountNumberLabel.text = "**** \(iban.suffix(4))"
        }
        
        cell.position = position
        cell.bankAccountListViewController = self
        
        return cell
        
    }
    
    func reloadList() {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    func changeDefaultAccount(position: Int){
        // Do it in firestore
        guard let uid = auth.currentUser?.uid else {return}
        if position == positionDefaultBankAccount {
            return
        }
        
        if positionDefaultBankAccount != 0 {
            db.collection("mangopay_customers").document(uid).collection("bank_accounts").document((defaultBankAccount?.id)!).setData(["isDefault" : false], merge: true) { (error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    return
                }
                self.bankAccountList[self.positionDefaultBankAccount].isDefault = false
                self.db.collection("mangopay_customers").document(uid).collection("bank_accounts").document(self.bankAccountList[position].id!).setData(["isDefault" : true], merge: true) { (error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                    self.positionDefaultBankAccount = position
                    self.defaultBankAccount = self.bankAccountList[position]
                    self.bankAccountList[position].isDefault = true
                    self.reloadList()
                }
                
            }
        } else {
            db.collection("mangopay_customers").document(uid).collection("bank_accounts").document(bankAccountList[position].id!).setData(["isDefault" : true], merge: true) { (error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    return
                }
                self.positionDefaultBankAccount = position
                self.defaultBankAccount = self.bankAccountList[position]
                self.bankAccountList[position].isDefault = true
                self.reloadList()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let lastItemIndex = bankAccountList.count - 1
        
        if index == lastItemIndex {
            // Add a BankAccount
            DispatchQueue.main.async {
                let addBankAccountViewController = AddBankAccountViewController()
                addBankAccountViewController.name = self.firstName + " " + self.lastName
                addBankAccountViewController.profileImageUrl = self.profileImageUrl
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(addBankAccountViewController, animated: true)
            }
        } else if index > 0 && index < lastItemIndex {
            // View Info credit card
            DispatchQueue.main.async {
                let modifyBankAccountVC = ModifyBankAccountVC()
                modifyBankAccountVC.name = self.firstName + " " + self.lastName
                modifyBankAccountVC.profileImageUrl = self.profileImageUrl
                modifyBankAccountVC.bankAccountModel = self.bankAccountList[index]

                // Add the credit card information
                self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
                self.navigationController?.pushViewController(modifyBankAccountVC, animated: true)
            }
        }
    }
    
}
