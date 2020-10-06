//
//  BankCardViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 26/12/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Stripe
import SwiftUI


class ListBankCardViewController : UIViewController {
    
    
    lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ditesmerci")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
    }
    
    @objc private func handleAddBankCard() {
        print("handle addbankcard")
        //choosePaymentButtonTapped()
        
    }
    
    // Stripe View
//    func choosePaymentButtonTapped() {
//        self.paymentContext!.pushPaymentOptionsViewController()
//    }
    
//    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
//        self.activityIndicator.animating = paymentContext.loading
//        self.paymentButton.enabled = paymentContext.selectedPaymentOption != nil
//        self.paymentLabel.text = paymentContext.selectedPaymentOption?.label
//        self.paymentIcon.image = paymentContext.selectedPaymentOption?.image
//    }
    
    // MARK: NavigationBar system
    func setupNavigationBar(){
        if let navControllerView = navigationController?.view {
            navControllerView.backgroundColor = .white
            navigationItem.titleView = bannerImageView
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(handleAddBankCard))
        }
    }
    
}
