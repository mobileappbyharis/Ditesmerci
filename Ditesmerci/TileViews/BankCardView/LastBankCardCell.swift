//
//  LastBankCardCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 18/02/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit



class LastBankCardCell: UICollectionViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ajouter une carte"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    lazy var visaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "visa")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var masterCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mastercard")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blueMerci
        setupViews()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    private func setupViews(){
        addSubview(titleLabel)
        addSubview(visaImageView)
        addSubview(masterCardImageView)

        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            masterCardImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            masterCardImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            masterCardImageView.widthAnchor.constraint(equalToConstant: 60),
            masterCardImageView.heightAnchor.constraint(equalToConstant: 60),

        ])
        
        NSLayoutConstraint.activate([
            visaImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            visaImageView.rightAnchor.constraint(equalTo: masterCardImageView.leftAnchor, constant: -20),
            visaImageView.widthAnchor.constraint(equalToConstant: 60),
            visaImageView.heightAnchor.constraint(equalToConstant: 60),
        ])
        
    }
    
}

