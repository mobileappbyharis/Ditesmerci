//
//  LoginViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 17/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class ShowcaseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    let cellId = "cellId"
    let infiniteSize = 100
    
//    var hasTopNotch: Bool {
//        if #available(iOS 11.0, tvOS 11.0, *) {
//            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
//        }
//        return false
//    }
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Inscription", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
        
    }()
    
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connexion", for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        return button
    }()
    
    
    
    
    
    @objc private func handleSignIn(){
        print("try to sign in")
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(LoginViewController(), animated: false)
        }
    }
    
    @objc private func handleSignUp(){
        print("try to sign up")
        DispatchQueue.main.async {
            self.navigationController?.view.layer.add(CATransition().segueFromRight(), forKey: nil)
            self.navigationController?.pushViewController(RegisterViewController(), animated: false)
        }
        
    }
    
    lazy var collectionView: UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
        pageControl.currentPageIndicatorTintColor = .blueMerci
        pageControl.numberOfPages = self.pagesName.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let pagesName: [String] = {
        let firstPage = "tuto1"
        let secondPage = "tuto2"
        let thirdPage = "tuto3"
        let fourthPage = "tuto4"
        let fifthPage = "tuto5"
        
        return [firstPage, secondPage, thirdPage, fourthPage, fifthPage]
    }()
    
    let pagesNameX: [String] = {
        let firstPage = "tutoX1"
        let secondPage = "tutoX2"
        let thirdPage = "tutoX3"
        let fourthPage = "tutoX4"
        let fifthPage = "tutoX5"
        
        return [firstPage, secondPage, thirdPage, fourthPage, fifthPage]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupViews()
        collectionView.register(ShowcasePage.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let midIndexPath = IndexPath(row: infiniteSize / 2, section: 0)
        collectionView.scrollToItem(at: midIndexPath,
                                    at: .centeredHorizontally,
                                    animated: false)
    }
    
    func setupViews(){
        setupCollectionView()
        setupStackView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infiniteSize
    }
    
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageControl(scrollView: scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControl(scrollView: scrollView)
    }
    
    
    func updatePageControl(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let count = pagesName.count
        let currentPageNumber = Int(pageNumber) % count
        pageControl.currentPage = currentPageNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ShowcasePage
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                // iPhone 5/5S/5C/SE
                let pageName = pagesName[indexPath.row % pagesName.count]
                cell.pageName = pageName
            case 1334:
                // iPhone 6/6S/7/8
                let pageName = pagesName[indexPath.row % pagesName.count]
                cell.pageName = pageName
            case 1920, 2208:
                // iPhone 6+/6S+/7+/8+
                let pageName = pagesName[indexPath.row % pagesName.count]
                cell.pageName = pageName
            case 2436:
                // iPhone X/XS
                let pageName = pagesNameX[indexPath.row % pagesNameX.count]
                cell.pageName = pageName
            case 2688:
                // iPhone XS Max
                let pageName = pagesNameX[indexPath.row % pagesNameX.count]
                cell.pageName = pageName
            case 1792:
                // iPhone XR
                let pageName = pagesNameX[indexPath.row % pagesNameX.count]
                cell.pageName = pageName
            default:
                print("Unknown")
            }
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(integerLiteral: 1100)
        return CGSize(width: collectionView.bounds.width, height: UIScreen.main.nativeBounds.height)
    }
    
    private func setupStackView(){
        let bottomControlsStackView = UIStackView(arrangedSubviews: [signUpButton, signInButton])
        
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(pageControl)
        view.addSubview(bottomControlsStackView)
        
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09)
            ])
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomControlsStackView.topAnchor, constant: -15),
            pageControl.heightAnchor.constraint(equalToConstant: 40)
            ])
        
    }
    
    private func setupCollectionView(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
    }
    
    
}

