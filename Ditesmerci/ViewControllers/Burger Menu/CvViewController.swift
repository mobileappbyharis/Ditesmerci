//
//  CvViewController.swift
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
import PDFGenerator
import PDFKit


class CvViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var profileImageUrl = "none"
    var firstName = ""
    var lastName = ""
    var job = ""
    var address = ""
    var thanks = 0
    var email = ""
    var validePhoneNumber = ""
    var companyName = ""
    var timestampBegin: Timestamp?
    var timestampEnd: Timestamp?
    var jobPlaceId = ""

    var reviewsList = [ReviewInfo]()


    private let firstCvCellId = "firstCvCellId"
    private let cvCellId = "cvCellId"
    
    lazy var sendPDFImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "send")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGenerateAndSharePDF)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blueMerci
        refreshControl.attributedTitle = NSAttributedString(string: "Chargement des données...")
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchReviews()
        self.refreshControl.endRefreshing()
    }
    
    private func removeReviews(){
        reviewsList.removeAll()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        view.backgroundColor = .white
        setupNavigationBar()
        // CollectionView
        collectionView.backgroundColor = UIColor.clear

        collectionView.register(FirstCvCell.self, forCellWithReuseIdentifier: firstCvCellId)
        collectionView.register(CvCell.self, forCellWithReuseIdentifier: cvCellId)

        collectionView.refreshControl = refreshControl
        fetchUserData()
        fetchReviews()

    }
    
    func setupNavigationBar(){
        if let sendPDFImage = sendPDFImageView.image {
            sendPDFImageView.image = sendPDFImage.resize(targetSize: CGSize(width: 30, height: 30))
            let barBurgerButton = UIBarButtonItem(customView: sendPDFImageView)
            self.navigationItem.rightBarButtonItem = barBurgerButton
        }

    }
    
    @objc private func handleGenerateAndSharePDF() {
        print("try to generate PDF and share it")
        generatePDF()
    }
    
    private func generatePDF(){
        let v1 = self.collectionView
        
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("cv.pdf"))
        // outputs as Data
        do {
            let data = try PDFGenerator.generated(by: [v1!])
            try data.write(to: dst, options: .atomic)
        } catch (let error) {
            print(error)
        }
        
        // writes to Disk directly.
        do {
            try PDFGenerator.generate([v1!], to: dst)
            self.savePdf(dst: dst)
            self.sharePDF()
            print("generated PDF")
        } catch (let error) {
            print(error)
        }
    }
    func savePdf(dst: URL){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("cv.pdf")
        let pdfDoc = NSData(contentsOf: dst)
        fileManager.createFile(atPath: paths as String, contents: pdfDoc as Data?, attributes: nil)
        print("saved PDF")
    }
    
    private func sharePDF(){
        let fileManager = FileManager.default
        let documentPath = (self.getDirectoryPath() as NSString).appendingPathComponent("cv.pdf")
        if fileManager.fileExists(atPath: documentPath){
            let document = NSData(contentsOfFile: documentPath)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [document!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
            print("share PDF")

        } else {
            print("document was not found")
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func fetchReviews(){
        print("try to fetch reviews")
        removeReviews()
        
        guard let uid = auth.currentUser?.uid else {return}
        self.db.collection("users").document(uid).collection("reviews").whereField("isReviewVisible", isEqualTo: true).whereField("isAddedToCv", isEqualTo: true).whereField("jobPlaceId", isEqualTo: jobPlaceId).order(by: "timestampCreation", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("failed to get reviews: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {return}
            
            for document in documents {
                let reviewInfo = ReviewInfo(dictionary: document.data())
                self.reviewsList.append(reviewInfo)
            }
            let fakeReviewInfo = ReviewInfo(dictionary: [
                "review": "test",
                ] as [AnyHashable : Any])
            
            self.reviewsList.insert(fakeReviewInfo, at: 0) // For the first cell

            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
            })
            
        }
    }
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            // Display First Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCvCellId, for: indexPath) as! FirstCvCell
            
            cell.nameLabel.text = firstName + " " + lastName
            cell.jobLabel.text = job
            cell.addressTextView.text = address
            cell.emailLabel.text = email
            cell.phoneNumberLabel.text = validePhoneNumber
            cell.thanksNumberLabel.text = String(thanks)
            cell.companyNameLabel.text = companyName
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr_FR")
            dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
            
            if let dateBegin = self.timestampBegin?.dateValue() {
                let strDateBegin = dateFormatter.string(from: dateBegin)
            
                if let dateEnd = self.timestampEnd?.dateValue() {
                    let strDateEnd = dateFormatter.string(from: dateEnd)
                
                    let finalStrTimestamp = "DU " + strDateBegin + " AU " + strDateEnd
                    cell.timestampLabel.text = finalStrTimestamp
                } else {
                    let finalStrTimestamp = "DEPUIS " + strDateBegin
                    cell.timestampLabel.text = finalStrTimestamp
                }
            }
            
            
            if self.profileImageUrl != "none" {
                let url = URL(string: self.profileImageUrl)
                let placeHolder = UIImage(named: "user")
                cell.profileImageView.kf.indicatorType = .activity
                cell.profileImageView.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvCellId, for: indexPath) as! CvCell
        
        let item = reviewsList[indexPath.item]
        
        if let review = item.review {
            cell.reviewTextView.text = review
        }
        
//        if let profileImageUrl = item.clientProfileImageUrl {
//            displayProfileImage(imageUrl: profileImageUrl, imageView: cell.profileImageView)
//        }
        
        if let timestampCreation = item.timestampCreation {
            let dateCreation = timestampCreation.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr_FR")
            dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
            let strDateCreation = dateFormatter.string(from: dateCreation)
            
            cell.timestampLabel.text = "Le " + strDateCreation

        }
        
        if let clientFirstName = item.clientFirstName {
            cell.firstNameLabel.text = clientFirstName

        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = reviewsList.count
        return count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let size: CGSize = CGSize(width: collectionView.frame.width, height: 270)
            return size
        }
        
        let size: CGSize = CGSize(width: collectionView.frame.width, height: 220)
        return size
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
            
            if let email = userInfo.email {
                self.email = email
            }
            
            if let phoneNumber = userInfo.phoneNumber {
                let subPhoneNumber = phoneNumber.dropFirst(3)
                let stringPhoneNumber = String(subPhoneNumber)
                self.validePhoneNumber = "0" + stringPhoneNumber
            }
            
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
