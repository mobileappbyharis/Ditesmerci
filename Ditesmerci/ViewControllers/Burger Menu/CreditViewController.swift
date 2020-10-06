//
//  CreditViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 16/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit



class CreditViewController : UIViewController {
    var profileViewController: ProfileViewController?

    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Informations et crédits"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    let firstIndicationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 11)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.text = "Informations et crédits"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()
        setupViews()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileViewController?.boolBurger = true
    }
    
    private func setupViews(){
        view.addSubview(label)
        
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            ])
    }
}
