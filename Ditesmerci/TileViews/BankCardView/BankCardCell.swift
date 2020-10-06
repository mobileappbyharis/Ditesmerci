//
//  BankCardCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 27/12/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase

class BankCardCell: UICollectionViewCell {
    var position: Int?
    var creditCardListViewController: CreditCardListViewController?

    lazy var verifyImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "validate")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.3
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSetDefaultCardMethodPayment)))
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Carte bancaire"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()

    let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "**** "
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    
    
    @objc private func handleSetDefaultCardMethodPayment() {
        print("trying to set default card payment")
        creditCardListViewController?.changeDefaultCard(position: self.position!)
    }

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blueMerci
        setupViews()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    private func setupViews(){
        addSubview(verifyImageView)
        addSubview(titleLabel)
        addSubview(cardNumberLabel)
        
        NSLayoutConstraint.activate([
            verifyImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            verifyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            verifyImageView.widthAnchor.constraint(equalToConstant: 30),
            verifyImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: verifyImageView.rightAnchor, constant: 5),
        ])
        
        NSLayoutConstraint.activate([
            cardNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardNumberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
        ])
    }
    
}
