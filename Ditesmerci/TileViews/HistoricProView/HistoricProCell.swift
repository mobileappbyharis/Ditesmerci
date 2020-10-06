//
//  HistoricProCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 19/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit



class HistoricProCell: UICollectionViewCell {
    
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    let jobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    lazy var bubbleImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "bubble")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let thanksNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
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
        addSubview(companyNameLabel)
        //addSubview(jobLabel)
        addSubview(timestampLabel)
        addSubview(bubbleImageView)
        addSubview(thanksNumberLabel)

        
        NSLayoutConstraint.activate([
            companyNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            companyNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            ])
//        let constraintJobLabel = NSLayoutConstraint(item: jobLabel,
//                                                          attribute: .centerX,
//                                                          relatedBy: .equal,
//                                                          toItem: self,
//                                                          attribute: .centerX,
//                                                          multiplier: 0.8,
//                                                          constant: 0)
//        constraintJobLabel.identifier = "jobLabel placement X"
//        addConstraint(constraintJobLabel)
//        NSLayoutConstraint.activate([
//            jobLabel.leftAnchor.constraint(equalTo: companyNameLabel.rightAnchor),
//            jobLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//            ])
        let constraintTimestampLabel = NSLayoutConstraint(item: timestampLabel,
                                                    attribute: .centerX,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .centerX,
                                                    multiplier: 1.4,
                                                    constant: 0)
        constraintTimestampLabel.identifier = "timestampLabel placement X"
        addConstraint(constraintTimestampLabel)
        
        NSLayoutConstraint.activate([
            timestampLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timestampLabel.rightAnchor.constraint(equalTo: bubbleImageView.leftAnchor)
            ])
        NSLayoutConstraint.activate([
            bubbleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bubbleImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            bubbleImageView.widthAnchor.constraint(equalToConstant: 30),
            bubbleImageView.heightAnchor.constraint(equalToConstant: 30)
            ])
        NSLayoutConstraint.activate([
            thanksNumberLabel.centerXAnchor.constraint(equalTo: bubbleImageView.centerXAnchor),
            thanksNumberLabel.centerYAnchor.constraint(equalTo: bubbleImageView.centerYAnchor)
            ])
        
        bubbleImageView.bringSubviewToFront(thanksNumberLabel)
    }
    
}
