//
//  LastBankAccountCell.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 01/06/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import UIKit



class LastBankAccountCell: UICollectionViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ajouter un compte bancaire"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
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
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
        ])
    }
    
}

