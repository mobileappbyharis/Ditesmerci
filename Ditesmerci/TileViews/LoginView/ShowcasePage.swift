//
//  ShowcasePage.swift
//  Ditesmerci
//
//  Created by 7k04 on 17/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit


class ShowcasePage: UICollectionViewCell {
    
    var pageName: String? {
        didSet {
            guard let pageName = pageName else {
                return
            }
            guard let image = UIImage(named: pageName) else {
                return
            }
            
            //            self.imageShowcase.image = image
            
            let screenSize = UIScreen.main.bounds
            
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            
            let size = CGSize(width: screenWidth, height: screenHeight)
            let resizedImage = self.resizeImage(image: image, targetSize: size)
            self.imageShowcase.layer.masksToBounds = true
            self.imageShowcase.image = image
        }
    }
    
    lazy var imageShowcase: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    func setupViews(){
        addSubview(imageShowcase)
        
        NSLayoutConstraint.activate([
            imageShowcase.heightAnchor.constraint(equalTo: heightAnchor),
            imageShowcase.widthAnchor.constraint(equalTo: widthAnchor),
            ])

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
