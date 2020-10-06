//
//  FirstCvCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 21/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//


import UIKit



class FirstCvCell: UICollectionViewCell {

    
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
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        
        return label
    }()
    
    let addressTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.textColor = .black
        textView.isSelectable = false
        textView.isEditable = false
        textView.isHidden = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 13)
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    let bluedivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blueMerci
        return view
    }()
    
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        addressTextView.autoSizingTextView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupViews(){
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(jobLabel)
        addSubview(addressTextView)
        addSubview(bubbleImageView)
        bubbleImageView.addSubview(thanksNumberLabel)
        bubbleImageView.bringSubviewToFront(thanksNumberLabel)
        addSubview(emailLabel)
        addSubview(phoneNumberLabel)
        addSubview(bluedivider)
        bluedivider.addSubview(companyNameLabel)
        bluedivider.addSubview(timestampLabel)

        
        let constraintProfileImageViewX = NSLayoutConstraint(item: profileImageView,
                                                     attribute: .centerX,
                                                     relatedBy: .equal,
                                                     toItem: self,
                                                     attribute: .centerX,
                                                     multiplier: 0.4,
                                                     constant: 0)
        constraintProfileImageViewX.identifier = "profileImageView placement X"
        addConstraint(constraintProfileImageViewX)
        
        let constraintProfileImageViewY = NSLayoutConstraint(item: profileImageView,
                                                             attribute: .centerY,
                                                             relatedBy: .equal,
                                                             toItem: self,
                                                             attribute: .centerY,
                                                             multiplier: 0.6,
                                                             constant: 0)
        constraintProfileImageViewY.identifier = "profileImageView placement Y"
        addConstraint(constraintProfileImageViewY)
        

        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 90),
            profileImageView.widthAnchor.constraint(equalToConstant: 90),
            ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 20),
            ])
        
        NSLayoutConstraint.activate([
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            jobLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor)
            ])
        
        NSLayoutConstraint.activate([
            addressTextView.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 10),
            addressTextView.rightAnchor.constraint(equalTo: rightAnchor),
            addressTextView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: -8),
            addressTextView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            bubbleImageView.topAnchor.constraint(equalTo: addressTextView.bottomAnchor),
            bubbleImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            bubbleImageView.heightAnchor.constraint(equalToConstant: 90),
            bubbleImageView.widthAnchor.constraint(equalToConstant: 90),
            ])
        
        NSLayoutConstraint.activate([
            thanksNumberLabel.centerXAnchor.constraint(equalTo: bubbleImageView.centerXAnchor),
            thanksNumberLabel.centerYAnchor.constraint(equalTo: bubbleImageView.centerYAnchor),
            ])
        
        NSLayoutConstraint.activate([
            emailLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor),
            emailLabel.topAnchor.constraint(equalTo: bubbleImageView.topAnchor, constant: 10),
            emailLabel.rightAnchor.constraint(equalTo: bubbleImageView.rightAnchor, constant: -10)
            ])
        
        NSLayoutConstraint.activate([
            phoneNumberLabel.leftAnchor.constraint(equalTo: emailLabel.leftAnchor),
            phoneNumberLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15),
            ])
        
        NSLayoutConstraint.activate([
            bluedivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            bluedivider.centerXAnchor.constraint(equalTo: centerXAnchor),
            bluedivider.widthAnchor.constraint(equalTo: widthAnchor),
            bluedivider.heightAnchor.constraint(equalToConstant: 20),
            ])

        NSLayoutConstraint.activate([
            companyNameLabel.leftAnchor.constraint(equalTo: bluedivider.leftAnchor, constant: 10),
            companyNameLabel.centerYAnchor.constraint(equalTo: bluedivider.centerYAnchor),
            ])
        
        NSLayoutConstraint.activate([
            timestampLabel.rightAnchor.constraint(equalTo: bluedivider.rightAnchor, constant: -5),
            timestampLabel.centerYAnchor.constraint(equalTo: bluedivider.centerYAnchor),
            ])

    }
    
}
