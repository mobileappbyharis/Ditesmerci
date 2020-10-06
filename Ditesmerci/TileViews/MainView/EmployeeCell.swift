//
//  EmployeeCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 11/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit


class EmployeeCell: UICollectionViewCell {
    
    weak var delegate : MainViewController?
    
    
    var employee: UserInfo? {
        didSet {
            if let employeeName = employee?.firstName {
                employeeNameLabel.text = employeeName
            }
        }
    }
    
    
    lazy var employeeImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        //imageView.layer.borderWidth = 1
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGiveViewController)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let employeeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    @objc private func handleGiveViewController(){
        print("trying to handle GiveViewController")
        let giveViewController = GiveViewController()
        giveViewController.employeeUid = employee?.uid
        let navController = UINavigationController(rootViewController: giveViewController)
        DispatchQueue.main.async {
            self.delegate?.present(navController, animated: true, completion: nil)
            //self.delegate?.navigationController?.pushViewController(giveViewController, animated: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        backgroundColor = .clear
        addSubview(employeeImageView)
        addSubview(employeeNameLabel)
        
        NSLayoutConstraint.activate([
            employeeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            employeeImageView.topAnchor.constraint(equalTo: topAnchor),
            employeeImageView.widthAnchor.constraint(equalToConstant: 100),
            employeeImageView.heightAnchor.constraint(equalToConstant: 100)
            
            ])
        
        NSLayoutConstraint.activate([
            employeeNameLabel.centerXAnchor.constraint(equalTo: employeeImageView.centerXAnchor),
            employeeNameLabel.topAnchor.constraint(equalTo: employeeImageView.bottomAnchor, constant: 5),
            ])
        
        //accessNameLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        
    }

    
}

