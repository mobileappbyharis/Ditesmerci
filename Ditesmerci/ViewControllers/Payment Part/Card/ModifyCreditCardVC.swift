//
//  ModifyCreditCardVC.swift
//  Ditesmerci
//
//  Created by 7k04 on 22/02/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class ModifyCreditCardVC : UIViewController {
    
    var name = "none"
    var profileImageUrl = "none"
    var card: CardModel?
    var db = Firestore.firestore()
    var auth = Auth.auth()
    
    
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
        label.text = "FirstName Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Informations financières"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        
        return label
    }()
    
    let cardInfoView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    let firstSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MA CARTE"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemPurple
        
        return label
    }()
    
    let firstDividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemPurple
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    lazy var brandCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "visa")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let brandCardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MASTERCARD"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        
        return label
    }()
    
    let last4digitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "****"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        
        return label
    }()
    
    let secondSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DATE D'EXPIRATION"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemPurple
        
        return label
    }()
    
    let secondDividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemPurple
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    let expDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MM/AAAA"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  SUPPRIMER  ", for: .normal)
        button.addTarget(self, action: #selector(handleDeleteCreditCardInfo), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blueMerci
        return button
    }()
    
    
    @objc private func handleDeleteCreditCardInfo() {
        deleteButton.isEnabled = false
        print("trying to delete card information")
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("mangopay_customers").document(uid).collection("cards").document((card?.id)!).setData(["Active": false], merge: true) { (error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            self.deleteButton.isEnabled = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        
        setupDisplayData()
        setupViews()
        
    }
    
    func setupDisplayData(){
        nameLabel.text = name
        if profileImageUrl != "none" {
            displayProfileImage(imageUrl: profileImageUrl, imageView: profileImageView)
        }
        
        if card != nil {
            brandCardLabel.text = card?.cardProvider!
            last4digitsLabel.text = String("*** - "+(card?.alias!.suffix(4))!)
            let expDate = card?.expirationDate!
            let expYear = String((expDate?.suffix(2))!)
            let expMonth = String((expDate?.prefix(2))!)
            expDateLabel.text = expMonth + "/" + expYear
            if card?.cardProvider! == "VISA" {
                brandCardImageView.image = UIImage(named: "visa")
            } else if card?.cardProvider! == "MASTERCARD" {
                brandCardImageView.image = UIImage(named: "mastercard")
            }
        }
    }
    
    
    func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(titleLabel)
        view.addSubview(cardInfoView)
        cardInfoView.addSubview(firstSubtitleLabel)
        cardInfoView.addSubview(firstDividerLineView)
        cardInfoView.addSubview(brandCardImageView)
        cardInfoView.addSubview(brandCardLabel)
        cardInfoView.addSubview(last4digitsLabel)
        cardInfoView.addSubview(secondSubtitleLabel)
        cardInfoView.addSubview(secondDividerLineView)
        cardInfoView.addSubview(expDateLabel)
        view.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: cardInfoView.bottomAnchor, constant: 50),
            deleteButton.centerXAnchor.constraint(equalTo: cardInfoView.centerXAnchor),
        ])
        NSLayoutConstraint.activate([
            expDateLabel.topAnchor.constraint(equalTo: secondSubtitleLabel.bottomAnchor, constant: 10),
            expDateLabel.centerXAnchor.constraint(equalTo: cardInfoView.centerXAnchor),
        ])
        NSLayoutConstraint.activate([
            secondDividerLineView.centerYAnchor.constraint(equalTo: secondSubtitleLabel.centerYAnchor),
            secondDividerLineView.leadingAnchor.constraint(equalTo: secondSubtitleLabel.trailingAnchor, constant: 5),
            secondDividerLineView.trailingAnchor.constraint(equalTo: cardInfoView.trailingAnchor),
            secondDividerLineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        NSLayoutConstraint.activate([
            secondSubtitleLabel.topAnchor.constraint(equalTo: brandCardImageView.bottomAnchor, constant: 10),
            secondSubtitleLabel.leadingAnchor.constraint(equalTo: cardInfoView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            last4digitsLabel.centerYAnchor.constraint(equalTo: brandCardImageView.centerYAnchor),
            last4digitsLabel.trailingAnchor.constraint(equalTo: cardInfoView.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            brandCardLabel.centerYAnchor.constraint(equalTo: brandCardImageView.centerYAnchor),
            brandCardLabel.centerXAnchor.constraint(equalTo: cardInfoView.centerXAnchor),
        ])
        NSLayoutConstraint.activate([
            brandCardImageView.topAnchor.constraint(equalTo: firstSubtitleLabel.bottomAnchor, constant: 10),
            brandCardImageView.leadingAnchor.constraint(equalTo: cardInfoView.leadingAnchor),
            brandCardImageView.heightAnchor.constraint(equalToConstant: 70),
            brandCardImageView.widthAnchor.constraint(equalToConstant: 70),
        ])
        NSLayoutConstraint.activate([
            firstDividerLineView.centerYAnchor.constraint(equalTo: firstSubtitleLabel.centerYAnchor),
            firstDividerLineView.leadingAnchor.constraint(equalTo: firstSubtitleLabel.trailingAnchor, constant: 5),
            firstDividerLineView.trailingAnchor.constraint(equalTo: cardInfoView.trailingAnchor),
            firstDividerLineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        NSLayoutConstraint.activate([
            firstSubtitleLabel.topAnchor.constraint(equalTo: cardInfoView.topAnchor),
            firstSubtitleLabel.leadingAnchor.constraint(equalTo: cardInfoView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            cardInfoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            cardInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardInfoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            cardInfoView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
        ])

    
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        let constraintNameLabel = NSLayoutConstraint(item: nameLabel,
                                                          attribute: .centerX,
                                                          relatedBy: .equal,
                                                          toItem: view,
                                                          attribute: .centerX,
                                                          multiplier: 1.2,
                                                          constant: 0)
        constraintNameLabel.identifier = "nameLabel placement X"
        view.addConstraint(constraintNameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            ])

        let constrainTitleLabel = NSLayoutConstraint(item: titleLabel,
                                                     attribute: .centerX,
                                                     relatedBy: .equal,
                                                     toItem: view,
                                                     attribute: .centerX,
                                                     multiplier: 1.4,
                                                     constant: 0)
        constrainTitleLabel.identifier = "titleLabel placement X"
        view.addConstraint(constrainTitleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
        ])
    }
}
