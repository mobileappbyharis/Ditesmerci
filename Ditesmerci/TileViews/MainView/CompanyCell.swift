//
//  CompanyCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 11/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CompanyCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let employeeCellId = "employeeCellId"
    weak var delegate : MainViewController?
    
    
    var expandableEmployeesList: ExpandableEmployeesList! {
        didSet {
            if expandableEmployeesList.employeesList.count > 0 {
                companyNameLabel.text = expandableEmployeesList.employeesList[0].jobCompanyName
            }
            employeeCollectionView.reloadData()
            
        }
    }
    
    
    
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Company Name"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blueMerci
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    
    
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black

        return label
    }()
    
    let employeeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .blueMerci
        pageControl.numberOfPages = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        backgroundColor = UIColor.clear
        
        employeeCollectionView.dataSource = self
        employeeCollectionView.delegate = self
        
        employeeCollectionView.register(EmployeeCell.self, forCellWithReuseIdentifier: employeeCellId)
        
        addSubview(employeeCollectionView)
        addSubview(companyNameLabel)
        addSubview(dividerLineView)
        addSubview(timestampLabel)
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            companyNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            companyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            companyNameLabel.centerYAnchor.constraint(equalTo: timestampLabel.centerYAnchor),
            ])
        
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            ])
        
        NSLayoutConstraint.activate([
            dividerLineView.centerYAnchor.constraint(equalTo: timestampLabel.centerYAnchor),
            dividerLineView.leadingAnchor.constraint(equalTo: companyNameLabel.trailingAnchor, constant: 5),
            dividerLineView.trailingAnchor.constraint(equalTo: timestampLabel.leadingAnchor, constant: -5),
            dividerLineView.heightAnchor.constraint(equalToConstant: 2)
            ])
        

        
        NSLayoutConstraint.activate([
            employeeCollectionView.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 8),
            employeeCollectionView.widthAnchor.constraint(equalTo: widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: employeeCollectionView.bottomAnchor, constant: 5),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        print("scrollViewDidchangeAdjustedContentInset")
        
    }
    
    override func dragStateDidChange(_ dragState: UICollectionViewCell.DragState) {
        print("dragStateDidChange")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = Int(scrollView.contentOffset.x / frame.width)
        pageControl.currentPage = pageNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expandableEmployeesList.employeesList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: employeeCellId, for: indexPath) as! EmployeeCell
        
        if(expandableEmployeesList.employeesList.count > 0){
            let employee = expandableEmployeesList.employeesList[indexPath.item]
            cell.employee = employee
            cell.delegate = delegate
            if expandableEmployeesList.isExpanded {
                self.pageControl.numberOfPages = Int(self.employeeCollectionView.contentSize.width / self.frame.width)
            }
            if let profileImageUrl = employee.profileImageUrlThumbnail {
                let url = URL(string: profileImageUrl)
                let placeHolder = UIImage(named: "user")
                cell.employeeImageView.kf.indicatorType = .activity
                cell.employeeImageView.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
                //cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
            
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize = CGSize(width: 110, height: 125)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // distance between items of a same list
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
