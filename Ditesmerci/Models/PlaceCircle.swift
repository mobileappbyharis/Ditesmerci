//
//  PlaceCircle.swift
//  Ditesmerci
//
//  Created by 7k04 on 12/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import Foundation
import GoogleMaps

class PlaceCircle: GMSCircle {
    let place: Geotification
    
    init(place: Geotification) {
        self.place = place
        super.init()
        
        position = place.coordinate
        radius = place.radius
        
        fillColor = .redAlpha
        strokeColor = .red
    }
}
