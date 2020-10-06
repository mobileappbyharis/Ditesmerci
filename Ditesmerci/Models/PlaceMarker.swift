//
//  PlaceMarker.swift
//  Ditesmerci
//
//  Created by 7k04 on 12/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import Foundation
import GoogleMaps

class PlaceMarker: GMSMarker {
    let place: Geotification
    
    init(place: Geotification) {
        self.place = place
        super.init()
        
        position = place.coordinate
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
