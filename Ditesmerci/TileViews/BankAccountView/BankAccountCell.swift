//
//  BankAccountCell.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 01/06/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase

class BankAccountCell: UICollectionViewCell {
    var position: Int?
    var bankAccountListViewController: BankAccountListViewController?

    lazy var verifyImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "validate")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.3
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSetDefaultCardMethodPayment)))
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mon compte bancaire"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()

    let bankAccountNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "**** ****"
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    
    
    @objc private func handleSetDefaultCardMethodPayment() {
        print("trying to set default bankAccount")
        // Function which change the default bank account
        bankAccountListViewController?.changeDefaultAccount(position: self.position!)
    }

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blueMerci
        setupViews()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    private func setupViews(){
        addSubview(verifyImageView)
        addSubview(titleLabel)
        addSubview(bankAccountNumberLabel)
        
        NSLayoutConstraint.activate([
            verifyImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            verifyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            verifyImageView.widthAnchor.constraint(equalToConstant: 30),
            verifyImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: verifyImageView.rightAnchor, constant: 5),
        ])
        
        NSLayoutConstraint.activate([
            bankAccountNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            bankAccountNumberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
        ])
    }
    
}

