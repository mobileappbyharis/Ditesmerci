//
//  ModifyBankAccountVC.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 01/06/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class ModifyBankAccountVC : UIViewController {
    
    var name = "none"
    var profileImageUrl = "none"
    var bankAccountModel: BankAccountModel?

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
    
    let bankAccountInfoView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    let firstSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MON COMPTE BANCAIRE"
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
    
    let nameBankAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MASTERCARD"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        
        return label
    }()
    
    let detailsBankAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Compte Personnel"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        
        return label
    }()
    
    let ibanBankAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "**** **** **** **** **** **** ***"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemPurple
        
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
        db.collection("mangopay_customers").document(uid).collection("bank_accounts").document((bankAccountModel?.id)!).setData(["Active": false, "isDefault": false], merge: true) { (error) in
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
        
        // TODO: Setup displaying bank account info
    }
    
    
    func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(titleLabel)
        view.addSubview(bankAccountInfoView)
        bankAccountInfoView.addSubview(firstSubtitleLabel)
        bankAccountInfoView.addSubview(firstDividerLineView)
        bankAccountInfoView.addSubview(nameBankAccountLabel)
        bankAccountInfoView.addSubview(detailsBankAccountLabel)
        bankAccountInfoView.addSubview(ibanBankAccountLabel)
        view.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: bankAccountInfoView.bottomAnchor, constant: 50),
            deleteButton.centerXAnchor.constraint(equalTo: bankAccountInfoView.centerXAnchor),
        ])
        NSLayoutConstraint.activate([
            ibanBankAccountLabel.topAnchor.constraint(equalTo: detailsBankAccountLabel.bottomAnchor, constant: 10),
            ibanBankAccountLabel.leadingAnchor.constraint(equalTo: bankAccountInfoView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            detailsBankAccountLabel.topAnchor.constraint(equalTo: nameBankAccountLabel.bottomAnchor, constant: 10),
            detailsBankAccountLabel.leadingAnchor.constraint(equalTo: bankAccountInfoView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            nameBankAccountLabel.topAnchor.constraint(equalTo: firstSubtitleLabel.bottomAnchor, constant: 10),
            nameBankAccountLabel.leadingAnchor.constraint(equalTo: bankAccountInfoView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            firstDividerLineView.centerYAnchor.constraint(equalTo: firstSubtitleLabel.centerYAnchor),
            firstDividerLineView.leadingAnchor.constraint(equalTo: firstSubtitleLabel.trailingAnchor, constant: 5),
            firstDividerLineView.trailingAnchor.constraint(equalTo: bankAccountInfoView.trailingAnchor),
            firstDividerLineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        NSLayoutConstraint.activate([
            firstSubtitleLabel.topAnchor.constraint(equalTo: bankAccountInfoView.topAnchor),
            firstSubtitleLabel.leadingAnchor.constraint(equalTo: bankAccountInfoView.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            bankAccountInfoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            bankAccountInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bankAccountInfoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            bankAccountInfoView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
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

