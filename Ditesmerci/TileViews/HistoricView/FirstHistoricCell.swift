//
//  FirstHistoricCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 05/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit



class FirstHistoricCell: UICollectionViewCell {
    
    let myMessagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mes Messages"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupViews(){
        addSubview(myMessagesLabel)
        
        NSLayoutConstraint.activate([
            myMessagesLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            myMessagesLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
    
}
