//
//  VisitedInfo.swift
//  Ditesmerci
//
//  Created by 7k04 on 23/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//


import UIKit
import Firebase
import FirebaseFirestore

class VisitedInfo: NSObject {
    var companyName: String?
    var employeesPresentUid: [String]?
    var timestampVisited: Timestamp?
    
    
    
    init(dictionary: [AnyHashable: Any]) {
        self.companyName = dictionary["companyName"] as? String
        self.employeesPresentUid = dictionary["employeesPresentUid"] as? [String]
        self.timestampVisited = dictionary["timestampVisited"] as? Timestamp
    }
}
