//
//  HistoricViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 16/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HistoricViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Firebase
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var user: User?
    var uid: String?
    var elementHistoricList = [ElementHistoricModel]()
    var sortedElementHistoricList = [[ElementHistoricModel]]()
    let sizeSwipeCell = 30
    
    // CollectionView
    private let historicCellId = "historicCellId"
    private let headerHistoricCellId = "headerHistoricCellId"
    private let firstHistoricCellId = "firstHistoricCellId"

    
    
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
        textView.text = ""
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.keyboardType = UIKeyboardType.alphabet
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.isSelectable = false
        return textView
    }()
    
    lazy var validationImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "validate")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancelReadReview)))
        return imageView
    }()
    
    var refreshControle: UIRefreshControl = {
        let refreshControle = UIRefreshControl()
        refreshControle.attributedTitle = NSAttributedString(string: "Chargement des données...")
        refreshControle.tintColor = .blueMerci
        refreshControle.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControle
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    

    
    @objc private func handleCancelReadReview(){
        print("try to hide read review")
        overlayView.isHidden = true
        self.tableView.isScrollEnabled = true

    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchHistoricData()
        self.refreshControle.endRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Auth Firebase
        user = auth.currentUser
        uid = user?.uid
        
        // Navigation Bar
        navigationItem.title = "Mes Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        setupViews()
        fetchHistoricData()
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.white
        
        tableView.register(HistoricCell.self, forCellReuseIdentifier: historicCellId)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Chargement des données...")
        tableView.refreshControl?.tintColor = .blueMerci
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        tableView.addSubview(refreshControle)

    }
    
    private func removeHistoricData(){
        elementHistoricList.removeAll()
        sortedElementHistoricList.removeAll()
        tableView.reloadData()
    }
    
    // execute getMercis() fetchReviews() & fetchPourboires()
     func fetchHistoricData(){
        print("try to fetch historic data")
        removeHistoricData()
        getMercis()
    }
    
    private func getMercis() {
        db.collection("users").document(uid!).collection("merci")
            .whereField("isThanked", isEqualTo: true).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("error fetch merci order by timestamp: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    return
                }
                
                for document in documents {
                    let merciInfo = MerciInfo(dictionary: document.data())
                    // Merci timestamp
                    if let timestampCreation = merciInfo.timestampCreation, let clientProfileImageUrl = merciInfo.clientProfileImageUrl {
                        let date = timestampCreation.dateValue()
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "fr_FR")
                        dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMMMd")
                        
                        let strDate = dateFormatter.string(from: date)
                        let dateSort = dateFormatter.date(from: strDate)

                        let element = ElementHistoricModel(dictionary: [
                            "isThanks": true,
                            "isReview": false,
                            "isPourboire": false,
                            "dateCreatedElement": dateSort!,
                            "clientProfileImageUrl": clientProfileImageUrl,
                            "timestampCreation": timestampCreation,
                            "amount": 0
                            ])
                        
                        self.elementHistoricList.append(element)
                        
                    }
                }
                
                self.fetchReviews()
        }
    }
    
    private func fetchReviews(){
        print("try to fetch reviews")
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("users").document(uid).collection("reviews").whereField("isReviewVisible", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error to fetch reviews: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {return}
            
            for document in documents {
                let reviewID = document.documentID
                let reviewInfo = ReviewInfo(dictionary: document.data())
                if let timestampCreation = reviewInfo.timestampCreation, let review = reviewInfo.review, let clientProfileImageUrl = reviewInfo.clientProfileImageUrl, let isOpen = reviewInfo.isOpen, let clientFirstName = reviewInfo.clientFirstName, let clientUid = reviewInfo.clientUid {
                    
                    let date = timestampCreation.dateValue()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "fr_FR")
                    dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMMMd")
                    
                    let strDate = dateFormatter.string(from: date)
                    let dateSort = dateFormatter.date(from: strDate)
                    
                    let element = ElementHistoricModel(dictionary: [
                        "isThanks": false,
                        "isReview": true,
                        "isPourboire": false,
                        "dateCreatedElement": dateSort!,
                        "clientProfileImageUrl": clientProfileImageUrl,
                        "review": review,
                        "reviewID": reviewID,
                        "isOpen": isOpen,
                        "timestampCreation": timestampCreation,
                        "clientFirstName": clientFirstName,
                        "clientUid": clientUid,
                        "amount": 0
                        ])
                    
                    
                    self.elementHistoricList.append(element)
                }
            }
            
            self.fetchPourboires()
        }
    }
    
    func fetchPourboires() {
        print("try to fetch pourboire")
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("users").document(uid).collection("pourboire").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {return}
            
            for document in documents {
                let pourboireID = document.documentID
                let pourboireInfo = PourboireInfo(dictionary: document.data())
                guard let timestampCreation = pourboireInfo.timestampCreation, let amount = pourboireInfo.amount, let clientProfileImageUrl = pourboireInfo.clientProfileImageUrl, let clientFirstName = pourboireInfo.clientFirstName, let clientUid = pourboireInfo.clientUid else {return}
                let date = timestampCreation.dateValue()
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "fr_FR")
                dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMMMd")
                
                let strDate = dateFormatter.string(from: date)
                let dateSort = dateFormatter.date(from: strDate)
                
                let element = ElementHistoricModel(dictionary: [
                    "isThanks": false,
                    "isReview": false,
                    "isPourboire": true,
                    "dateCreatedElement": dateSort!,
                    "clientProfileImageUrl": clientProfileImageUrl,
                    "pourboireID": pourboireID,
                    "amount": amount,
                    "timestampCreation": timestampCreation,
                    "clientFirstName": clientFirstName,
                    "clientUid": clientUid
                ])
                
                
                self.elementHistoricList.append(element)
                
            }
            let groupedElements = Dictionary(grouping: self.elementHistoricList, by: { (element) -> Date in
                return element.dateCreatedElement!
            })
            
            // C'est au niveau du sorted by keys que ça bug
            let sortedKeys = groupedElements.keys.sorted(by: >)
            sortedKeys.forEach { (key) in
                let values = groupedElements[key]
                let valuesSorted = values?.sorted(by: { $0.timestampCreation?.compare($1.timestampCreation!) == .orderedDescending })
                self.sortedElementHistoricList.append(valuesSorted ?? [])
            }
            print("sortedElement count: \(self.sortedElementHistoricList.count)")
            print("valuesSorted count: \(self.sortedElementHistoricList[0].count)")
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
        
    }
    
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item: ElementHistoricModel
        item = sortedElementHistoricList[indexPath.section][indexPath.row]
        if item.isReview == false {
            let configuration = UISwipeActionsConfiguration(actions: [])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        }
        
        let reportAction =  UIContextualAction(style: .normal, title: "report", handler: { (action,view,completionHandler ) in
            self.db.collection("reports").document(item.reviewID!).setData([
                "review": item.review ?? "none",
                "clientProfileImageUrl": item.clientProfileImageUrl ?? "none",
                "clientFirstName": item.clientFirstName ?? "none",
                "reportedUid": item.clientUid ?? "none",
                "complainUid": self.uid!
                ] as [String : Any], merge: true, completion: { err in
                    if let err = err {
                        print("Failed add report: \(err)")
                    } else {
                        print("success add report")
                        self.displayAlertErrorUI(title: "Rapport envoyé", message: "Nous vous remercions d'avoir signalé cet utilisateur. Nous examinerons le contenu de son message.", answer: "ok")
                        completionHandler(true)
                    }
            })
        })
        reportAction.image = self.resizeImage(image: UIImage(named: "exclamation")!, targetSize: CGSize(width: sizeSwipeCell, height: sizeSwipeCell))
        reportAction.backgroundColor = .yellowMerciSwipe
        
        
        let trashAction =  UIContextualAction(style: .normal, title: "trash", handler: { (action,view,completionHandler ) in
            //do stuff
            self.db.collection("users").document(self.uid!).collection("reviews").document(item.reviewID!).setData([
                "isAddedToCv": false,
                ] as [String : Any], merge: true, completion: { err in
                    if let err = err {
                        print("Failed store added false to isAddedToCv: \(err)")
                        
                    } else {
                        print("Success store added false to isAddedToCv")
                        completionHandler(true)
                    }
            })
        })
        trashAction.image = self.resizeImage(image: UIImage(named: "trash")!, targetSize: CGSize(width: sizeSwipeCell, height: sizeSwipeCell))
        trashAction.backgroundColor = .yellowMerciSwipe2
        
        
        let cvAction =  UIContextualAction(style: .normal, title: "addToCv", handler: { (action,view,completionHandler ) in
            //do stuff
            self.db.collection("users").document(self.uid!).collection("reviews").document(item.reviewID!).setData([
                "isAddedToCv": true,
                "timestampAddedToCv": FieldValue.serverTimestamp()
                ] as [String : Any], merge: true, completion: { err in
                    if let err = err {
                        print("Failed store added to cv: \(err)")
                        
                    } else {
                        print("success store added to cv")
                        completionHandler(true)
                    }
                })
            })
            
        cvAction.image = self.resizeImage(image: UIImage(named: "cv")!, targetSize: CGSize(width: sizeSwipeCell, height: sizeSwipeCell))
        cvAction.backgroundColor = .yellowMerciSwipe
        
        
        let configuration = UISwipeActionsConfiguration(actions: [reportAction, trashAction, cvAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }

    
     func numberOfSections(in tableView: UITableView) -> Int {
        let count = sortedElementHistoricList.count
        return count
    }


     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 80)
    }

     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        let dividerLineView = UIView()
        containerView.backgroundColor = .white
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView.backgroundColor = .black
     
        let timestampLabel = UILabel()
         let firstElementInSection = self.sortedElementHistoricList[section].first
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        if let dateSort = firstElementInSection?.dateCreatedElement {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr_FR")
            dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMMMd")
            let strDate = dateFormatter.string(from: dateSort)
            
            timestampLabel.text = strDate
            timestampLabel.font = UIFont.boldSystemFont(ofSize: 18)
            timestampLabel.textColor = .black
        }

        
        containerView.addSubview(timestampLabel)
        containerView.addSubview(dividerLineView)
        
        
        
        NSLayoutConstraint.activate([
            timestampLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            timestampLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20)
            ])
        
        NSLayoutConstraint.activate([
            dividerLineView.centerYAnchor.constraint(equalTo: timestampLabel.centerYAnchor),
            dividerLineView.leftAnchor.constraint(equalTo: timestampLabel.rightAnchor, constant: 5),
            dividerLineView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15),
            dividerLineView.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let element = sortedElementHistoricList[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: historicCellId, for: indexPath) as! HistoricCell
        
        if let profileImageUrl = element.clientProfileImageUrl {
            let url = URL(string: profileImageUrl)
            let placeHolder = UIImage(named: "user")
            cell.photoImageView.kf.indicatorType = .activity
            cell.photoImageView.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        guard let isThanks = element.isThanks, let isReview = element.isReview, let isPourboire = element.isPourboire, let amount = element.amount else {return cell}
            if isThanks {
                cell.merciImageView.isHidden = false
                cell.messageImageView.isHidden = true
            } else if isPourboire {
                cell.pourboireLabel.text = "\(amount) €"
                cell.messageImageView.isHidden = true
                cell.merciImageView.isHidden = true
            } else if isReview {
                print("im here : \(element)")
                cell.merciImageView.isHidden = true
                cell.messageImageView.isHidden = false

                cell.elementHistoricModel = element
                
                if let isOpen = element.isOpen {
                    if isOpen {
                        cell.messageImageView.image = UIImage(named: "letteropen")
                    } else {
                        cell.messageImageView.image = UIImage(named: "letterclosed")
                    }
                    cell.section = indexPath.section
                    cell.row = indexPath.row
                    cell.historicViewController = self
                }
            }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = sortedElementHistoricList[section].count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row == 0 {
//            let size: CGSize = CGSize(width: view.frame.width, height: 120)
//            return size
//        }
        let size: CGSize = CGSize(width: view.frame.width, height: 80)
        return size
    }
    
    private func setupViews() {
        view.addSubview(overlayView)
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        overlayView.center = CGPoint(x: w/2, y: h/2)
        
        NSLayoutConstraint.activate([
            overlayView.widthAnchor.constraint(equalTo: view.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: view.heightAnchor),
            ])
        setupReviewViews()
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
    
    
}
