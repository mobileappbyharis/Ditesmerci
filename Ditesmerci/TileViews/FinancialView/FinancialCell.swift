//
//  HistoricProCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 19/07/2020.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit

class FinancialCell: UICollectionViewCell {
    
    let actionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.textColor = .black
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
        addSubview(actionLabel)
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            actionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            ])
        
        NSLayoutConstraint.activate([
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            amountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
        ])
    }
    
}
