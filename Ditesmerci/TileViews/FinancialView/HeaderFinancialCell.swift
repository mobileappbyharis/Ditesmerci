//
//  HeaderHistoricProCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 19/07/2020.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit


class HeaderFinancialCell: UICollectionViewCell {
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purpleMerci
        return view
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .purpleMerci
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
        addSubview(timestampLabel)
        addSubview(dividerLineView)
        
        
        
        NSLayoutConstraint.activate([
            timestampLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timestampLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
            ])
        
        NSLayoutConstraint.activate([
            dividerLineView.centerYAnchor.constraint(equalTo: timestampLabel.centerYAnchor),
            dividerLineView.leftAnchor.constraint(equalTo: timestampLabel.rightAnchor, constant: 5),
            dividerLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            dividerLineView.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
}
