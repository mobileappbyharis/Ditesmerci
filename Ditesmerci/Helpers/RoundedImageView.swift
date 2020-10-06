//
//  RoundedImageView.swift
//  Ditesmerci
//
//  Created by 7k04 on 16/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit



class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = self.frame.width/2.0
        layer.cornerRadius = radius
        clipsToBounds = true // This could get called in the (requiered) initializer
        // or, ofcourse, in the interface builder if you are working with storyboards
    }
    
}

