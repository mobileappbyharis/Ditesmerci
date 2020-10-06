//
//  FirstBankAccountCell.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 19/07/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit

class FirstFinancialCell: UICollectionViewCell {
    
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
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Historique financier"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupViews(){
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(nameLabel)

        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            ])
        
        let constraintNameLabel = NSLayoutConstraint(item: nameLabel,
                                                          attribute: .centerX,
                                                          relatedBy: .equal,
                                                          toItem: self,
                                                          attribute: .centerX,
                                                          multiplier: 1.2,
                                                          constant: 0)
        constraintNameLabel.identifier = "nameLabel placement X"
        addConstraint(constraintNameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            ])
        
        let constrainTitleLabel = NSLayoutConstraint(item: titleLabel,
                                                     attribute: .centerX,
                                                     relatedBy: .equal,
                                                     toItem: self,
                                                     attribute: .centerX,
                                                     multiplier: 1.4,
                                                     constant: 0)
        constrainTitleLabel.identifier = "titleLabel placement X"
        addConstraint(constrainTitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            ])
        
    }
    
}

