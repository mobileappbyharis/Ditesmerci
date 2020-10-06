//
//  HistoricCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 22/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class HistoricCell: UITableViewCell {
    
    var elementHistoricModel: ElementHistoricModel?
    
    
    var historicViewController: HistoricViewController?
    
    var section: Int? {
        didSet {
            
        }
    }
    
    var row: Int? {
        didSet {
            
        }
    }
    
    
    lazy var photoImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var merciImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mercihistoric")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "letterclosed")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReadMessage)))

        return imageView
    }()
    
    let pourboireLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    
    @objc private func handleReadMessage(){
        print("try to read Message")
        if let review = elementHistoricModel?.review, let reviewID = elementHistoricModel?.reviewID {
            print("try to read Message")
            self.historicViewController?.reviewTextView.text = review
            self.historicViewController?.overlayView.isHidden = false
            self.historicViewController?.tableView.isScrollEnabled = false
            setIsOpenTrueToFirestore(reviewID: reviewID)
        }
    }
    
    private func setIsOpenTrueToFirestore(reviewID: String){
        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            db.collection("users").document(uid).collection("reviews").document(reviewID).setData([
                "isOpen": true
            ], merge: true) { (error) in
                if let error = error {
                    print("error set isOpen true: \(error)")
                } else {
                    print("sucess to set isOpen true")
                    self.messageImageView.image = UIImage(named: "letteropen")
                    self.historicViewController?.sortedElementHistoricList[self.section!][self.row!].isOpen = true
                }
            }
            
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()

    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    private func setupViews(){
        addSubview(photoImageView)
        addSubview(merciImageView)
        addSubview(messageImageView)
        addSubview(pourboireLabel)

        let constraintPhotoImageView = NSLayoutConstraint(item: photoImageView,
                                                            attribute: .centerX,
                                                            relatedBy: .equal,
                                                            toItem: self,
                                                            attribute: .centerX,
                                                            multiplier: 0.3,
                                                            constant: 0)
        constraintPhotoImageView.identifier = "photoImageView placement X"
        addConstraint(constraintPhotoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 60),
            photoImageView.heightAnchor.constraint(equalToConstant: 60),

            ])
        
        let constraintMerciImageView = NSLayoutConstraint(item: merciImageView,
                                            attribute: .centerX,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .centerX,
                                            multiplier: 0.82,
                                            constant: 0)
        constraintMerciImageView.identifier = "merciImageView placement X"
        addConstraint(constraintMerciImageView)

        NSLayoutConstraint.activate([
            merciImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            merciImageView.widthAnchor.constraint(equalToConstant: 65),
            merciImageView.heightAnchor.constraint(equalToConstant: 65),
            ])
        
        let constraintMessageImageView = NSLayoutConstraint(item: messageImageView,
                                                          attribute: .centerX,
                                                          relatedBy: .equal,
                                                          toItem: self,
                                                          attribute: .centerX,
                                                          multiplier: 1.32,
                                                          constant: 0)
        constraintMessageImageView.identifier = "messageImageView placement X"
        addConstraint(constraintMessageImageView)
        
        NSLayoutConstraint.activate([
            messageImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageImageView.widthAnchor.constraint(equalToConstant: 35),
            messageImageView.heightAnchor.constraint(equalToConstant: 35),
            ])
        
        
        let constraintPourboireLabel = NSLayoutConstraint(item: pourboireLabel,
                                                          attribute: .centerX,
                                                          relatedBy: .equal,
                                                          toItem: self,
                                                          attribute: .centerX,
                                                          multiplier: 1.78,
                                                          constant: 0)
        constraintPourboireLabel.identifier = "pourboireLabel placement X"
        addConstraint(constraintPourboireLabel)
        NSLayoutConstraint.activate([
            pourboireLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        
    }
}
