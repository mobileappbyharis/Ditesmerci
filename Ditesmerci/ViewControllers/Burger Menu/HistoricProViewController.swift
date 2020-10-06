//
//  HistoricProViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 19/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Kingfisher
class HistoricProViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // Firebase
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var uid: String?
    var profileImageUrl = "none"
    var firstName = "none"
    var lastName = "none"
    var elementHistoricProList = [JobInfo]()
    var sortedElementHistoricProList = [[JobInfo]]()
    var profileViewController: ProfileViewController?

    
    // CollectionView
    private let historicProCellId = "historicProCellId"
    private let headerHistoricProCellId = "headerHistoricProCellId"
    private let firstHistoricProCellId = "firstHistoricProCellId"

    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blueMerci
        refreshControl.attributedTitle = NSAttributedString(string: "Chargement des données...")
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchHistoricProData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileViewController?.boolBurger = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()

        // CollectionView
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(FirstHistoricProCell.self, forCellWithReuseIdentifier: firstHistoricProCellId)
        collectionView.register(HistoricProCell.self, forCellWithReuseIdentifier: historicProCellId)
        
        collectionView.register(HeaderHistoricProCell.self, forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerHistoricProCellId)

        collectionView.refreshControl = refreshControl
        
        fetchHistoricProData()
    }
    
    private func removeHistoricProData(){
        elementHistoricProList.removeAll()
        sortedElementHistoricProList.removeAll()
        collectionView.reloadData()
    }
    
    
    private func fetchHistoricProData(){
        print("try to fetch historic data")
        removeHistoricProData()
        
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("users").document(uid).collection("jobs").order(by: "timestampBegin", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error fetch jobs order by timestamp: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.getAndOrderList(documents: documents)
        }
    }
    
    
    private func getAndOrderList(documents: [QueryDocumentSnapshot]){
        for document in documents {
            let jobInfo = JobInfo(dictionary: document.data())
            let jobPlaceId = document.documentID
            jobInfo.jobPlaceId = jobPlaceId
            if let timestampBegin = jobInfo.timestampBegin {
                let date = timestampBegin.dateValue()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "fr_FR")
                dateFormatter.setLocalizedDateFormatFromTemplate("yyyy")
                let strDate = dateFormatter.string(from: date)
                jobInfo.timestampYearString = strDate
                self.elementHistoricProList.append(jobInfo)
                
            }
            
        }
        

        // Because we don't want a header for the first item
        let fakeTimestampBegin = Timestamp(seconds: 100, nanoseconds: 100)

        let fakeJobInfo = JobInfo(dictionary: [
            "timestampBegin": fakeTimestampBegin,
            "timestampYearString": ""
            ]as [AnyHashable : Any])
        var fakeSection = [JobInfo]()
        fakeSection.append(fakeJobInfo)
        // Because we don't want a header for the first item

        
        let groupedElements = Dictionary(grouping: self.elementHistoricProList, by: { (element) -> String in
            return element.timestampYearString ?? "none"
        })
        
        let sortedKeys = groupedElements.keys.sorted(by: >)
        sortedKeys.forEach { (key) in
            let values = groupedElements[key]
            let valuesSorted = values?.sorted(by: { $0.timestampBegin?.compare($1.timestampBegin!) == .orderedDescending })
            self.sortedElementHistoricProList.append(valuesSorted ?? [])
        }
        self.sortedElementHistoricProList.insert(fakeSection, at: 0)
        
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }

    
        override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                    headerHistoricProCellId, for: indexPath) as! HeaderHistoricProCell
                if indexPath.section == 0 {
                    header.dividerLineView.isHidden = true
                    header.timestampLabel.isHidden = true
                    return header
                }
                let firstElementInSection = self.sortedElementHistoricProList[indexPath.section].first
                let dateString = firstElementInSection?.timestampYearString
                header.dividerLineView.isHidden = false
                header.timestampLabel.isHidden = false
                header.timestampLabel.text = dateString
                return header
            default: assert(false, "Unexpected element kind")
            }
        }
        
    
    
    
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstHistoricProCellId, for: indexPath) as! FirstHistoricProCell

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
            
            let element = sortedElementHistoricProList[indexPath.section][indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historicProCellId, for: indexPath) as! HistoricProCell
            if let companyName = element.jobCompanyName {
                cell.companyNameLabel.text = companyName
            }
            
            if let job = element.job {
                cell.jobLabel.text = job
            }
            
            if let thanksNumber = element.thanks {
                cell.thanksNumberLabel.text = String(thanksNumber)
            } else {
                cell.thanksNumberLabel.text = "0"
            }
            if let timestampBegin = element.timestampBegin {
                let dateBegin = timestampBegin.dateValue()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "fr_FR")
                dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
                let strDateBegin = dateFormatter.string(from: dateBegin)
                
                if let timestampEnd = element.timestampEnd {
                    let dateEnd = timestampEnd.dateValue()
                    
                    
                    
                    let strDateEnd = dateFormatter.string(from: dateEnd)
                    
                    let finalStrTimestamp = "DU " + strDateBegin + " AU " + strDateEnd
                    cell.timestampLabel.text = finalStrTimestamp
                } else {
                    cell.timestampLabel.text = "DEPUIS " + strDateBegin
                }
            }
            
            return cell
        }
    
    // Sections Number
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = sortedElementHistoricProList.count
        return count
    }
    
    // Items Number in Sections
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = sortedElementHistoricProList[section].count
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let itemClicked = sortedElementHistoricProList[section][row]

        let cvViewController = CvViewController(collectionViewLayout: UICollectionViewFlowLayout())
        guard let jobPlaceId = itemClicked.jobPlaceId else {return}
        cvViewController.jobPlaceId = jobPlaceId
        
        if let job = itemClicked.job {
            cvViewController.job = job
        }
        
        if let jobCompanyName = itemClicked.jobCompanyName {
            cvViewController.companyName = jobCompanyName
        }
        
        if let address = itemClicked.jobFormattedAddress {
            cvViewController.address = address
        }
        
        if let timestampBegin = itemClicked.timestampBegin {
            cvViewController.timestampBegin = timestampBegin
        }
        if let timestampEnd = itemClicked.timestampEnd {
            cvViewController.timestampEnd = timestampEnd
        }
        
        if let thanks = itemClicked.thanks {
            cvViewController.thanks = thanks
        }
        
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(cvViewController, animated: true)
        }
        
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
