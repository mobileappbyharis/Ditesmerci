//
//  HeaderHistoricCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 22/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit


class HeaderHistoricCell: UITableViewCell {
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7 février 2018"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupViews()
        
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .clear
//        setupViews()
//    }
    
    
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
