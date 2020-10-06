//
//  PourboireInfo.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 12/07/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//
import Foundation
import Firebase
import FirebaseFirestore

class PourboireInfo: NSObject {
    var amount: Int?
    var clientFirstName: String?
    var clientProfileImageUrl: String?
    var clientUid: String?
    var jobPlaceId: String?
    var timestampCreation: Timestamp?
    var timestampModification: Timestamp?
    
    
    init(dictionary: [AnyHashable: Any]) {
        self.amount = dictionary["amount"] as? Int
        self.clientFirstName = dictionary["clientFirstName"] as? String
        self.clientProfileImageUrl = dictionary["clientProfileImageUrl"] as? String
        self.clientUid = dictionary["clientUid"] as? String
        self.jobPlaceId = dictionary["jobPlaceId"] as? String
        self.timestampCreation = dictionary["timestampCreation"] as? Timestamp
        self.timestampModification = dictionary["timestampModification"] as? Timestamp
    }
}
