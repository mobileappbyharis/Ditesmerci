//
//  CompanyInfo.swift
//  Ditesmerci
//
//  Created by 7k04 on 11/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CompanyInfo: NSObject {
    // Not necessarily the center of the place
    var center: GeoPoint?
    var coordinate: GeoPoint?
    var formattedAddress: String?
    var name: String?
    var northEastCoordinate: GeoPoint?
    var placeID: String?
    var radius: String?
    var southWestCoordinate: GeoPoint?
    var types: [String]?
    
    
    
    init(dictionary: [AnyHashable: Any]) {
        self.center = dictionary["center"] as? GeoPoint
        self.coordinate = dictionary["coordinate"] as? GeoPoint
        self.formattedAddress = dictionary["formattedAddress"] as? String
        self.name = dictionary["name"] as? String
        self.northEastCoordinate = dictionary["northEastCoordinate"] as? GeoPoint
        self.placeID = dictionary["placeID"] as? String
        self.radius = dictionary["radius"] as? String
        self.southWestCoordinate = dictionary["southWestCoordinate"] as? GeoPoint
        self.types = dictionary["types"] as? [String]
    }
}
