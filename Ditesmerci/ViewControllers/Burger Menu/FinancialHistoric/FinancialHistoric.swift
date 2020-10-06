//
//  FinancialHistoric.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 19/07/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class FinancialHistoric: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var profileImageUrl = "none"
    var firstName = "none"
    var lastName = "none"
    var financialList = [FinancialModel]()
    var sortedFinancialList = [[FinancialModel]]()
    var profileViewController: ProfileViewController?
    
    // CollectionView
    private let firstFinancialCellId = "firstFinancialCellId"
    private let financialCellId = "financialCellId"
    private let headerFinancialCellId = "headerFinancialCellId"
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blueMerci
        refreshControl.attributedTitle = NSAttributedString(string: "Chargement des données...")
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchFinancialData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        setupBackButton()

        // CollectionView
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(FirstFinancialCell.self, forCellWithReuseIdentifier: firstFinancialCellId)
        collectionView.register(FinancialCell.self, forCellWithReuseIdentifier: financialCellId)
        collectionView.register(HeaderFinancialCell.self, forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerFinancialCellId)

        collectionView.refreshControl = refreshControl
        
        fetchFinancialData()
    }
    
    private func removeFiancialData(){
        financialList.removeAll()
        sortedFinancialList.removeAll()
        collectionView.reloadData()
    }
    
    
    private func fetchFinancialData(){
        print("try to fetch historic data")
        removeFiancialData()
        
        guard let uid = auth.currentUser?.uid else {return}
        
        db.collection("users").document(uid).collection("financial").order(by: "executionDate", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error fetch jobs order by timestamp: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                return
            }
            print("taille documents: \(documents.count)")
            
            self.getAndOrderList(documents: documents)
        }
    }
    
    
    private func getAndOrderList(documents: [QueryDocumentSnapshot]){
        for document in documents {
            print("yoyo")
            let financialData = FinancialModel(dictionary: document.data())
            guard let executionDate = financialData.executionDate else {return}
            let date = executionDate.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr_FR")
            dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM yyyy")
            
            
            let strDate = dateFormatter.string(from: date)
            financialData.executionDateString = strDate
            self.financialList.append(financialData)
        }
        

        // Because we don't want a header for the first item
        let fakeDate = Date(timeIntervalSinceReferenceDate: -123456789.0) // Feb 2, 1997, 10:26 AM

        let fakeFinancialData = FinancialModel(dictionary: [
            "executionDate": fakeDate,
            "executionDateString": ""
            ]as [AnyHashable : Any])
        
        var fakeSection = [FinancialModel]()
        
        fakeSection.append(fakeFinancialData)
        // Because we don't want a header for the first item

        
        let groupedElements = Dictionary(grouping: self.financialList, by: { (element) -> String in
            return element.executionDateString ?? "none"
        })
        
        let sortedKeys = groupedElements.keys.sorted(by: >)
        sortedKeys.forEach { (key) in
            let values = groupedElements[key]
            let valuesSorted = values?.sorted(by: { $0.executionDate?.compare($1.executionDate!) == .orderedDescending })
            self.sortedFinancialList.append(valuesSorted ?? [])
        }
        self.sortedFinancialList.insert(fakeSection, at: 0)
        
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }

    
        override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                    headerFinancialCellId, for: indexPath) as! HeaderFinancialCell
                if indexPath.section == 0 {
                    header.dividerLineView.isHidden = true
                    header.timestampLabel.isHidden = true
                    return header
                }
                let firstElementInSection = self.sortedFinancialList[indexPath.section].first
                let dateString = firstElementInSection?.executionDateString
                header.dividerLineView.isHidden = false
                header.timestampLabel.isHidden = false
                header.timestampLabel.text = dateString
                return header
        }
    
    
    
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstFinancialCellId, for: indexPath) as! FirstFinancialCell

                if self.profileImageUrl != "none" {
                    let url = URL(string: self.profileImageUrl)
                    let placeHolder = UIImage(named: "user")
                    cell.profileImageView.kf.indicatorType = .activity
                    cell.profileImageView.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
                }
                let name = self.firstName + " " + self.lastName
                cell.nameLabel.text = name

                return cell
            }
            
            let element = sortedFinancialList[indexPath.section][indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: financialCellId, for: indexPath) as! FinancialCell
            
            if let amount = element.amount {
                cell.amountLabel.text = String(amount)
            }
            
            if let executionDate = element.executionDate, let action = element.action  {
                let date = executionDate.dateValue()

                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "fr_FR")
                dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
                let strDateHour = dateFormatter.string(from: date)
                cell.actionLabel.text = "\(strDateHour) - \(action.uppercased())"

            }
            
            return cell
        }
    
    // Sections Number
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = sortedFinancialList.count
        return count
    }
    
    // Items Number in Sections
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = sortedFinancialList[section].count
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click on item")
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            let size: CGSize = CGSize(width: view.frame.width, height: 0)
            return size
        }
        
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let size: CGSize = CGSize(width: view.frame.width, height: 120)
            return size
        }
        
        let size: CGSize = CGSize(width: view.frame.width, height: 35)
        return size
    }
    
}
