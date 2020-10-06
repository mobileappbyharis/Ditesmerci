//
//  CvCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 21/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit


class CvCell: UICollectionViewCell {

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        return view
    }()
    
    lazy var profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isOpaque = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .blueMerci
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .blueMerci
        return label
    }()
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.keyboardType = UIKeyboardType.alphabet
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.isSelectable = false
        return textView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupViews(){
        addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(firstNameLabel)
        containerView.addSubview(timestampLabel)
        containerView.addSubview(reviewTextView)
        
        // Layer
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
        layer.addSublayer(profileImageView.layer)
        layer.insertSublayer(self.containerView.layer, below: profileImageView.layer)

        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            ])
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: containerView.topAnchor),
            profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            ])
        
        NSLayoutConstraint.activate([
            firstNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            firstNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10),
            ])
        
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            timestampLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            ])
        
        NSLayoutConstraint.activate([
            reviewTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            reviewTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            reviewTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            reviewTextView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            ])
    }
    
}
