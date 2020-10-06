//
//  ElementHistoricModel.swift
//  Ditesmerci
//
//  Created by 7k04 on 30/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class ElementHistoricModel: NSObject {
    var clientFirstName: String?
    var clientProfileImageUrl: String?
    var clientUid: String?
    var dateCreatedElement: Date?
    var isOpen: Bool?
    var isAddedToCv: Bool?
    var isThanks: Bool?
    var review: String?
    var reviewID: String?
    var timestampAddedCV: Timestamp?
    var timestampCreation: Timestamp?

    
    init(dictionary: [AnyHashable: Any]) {
        self.clientFirstName = dictionary["clientFirstName"] as? String
        self.clientProfileImageUrl = dictionary["clientProfileImageUrl"] as? String
        self.clientUid = dictionary["clientUid"] as? String
        self.dateCreatedElement = dictionary["dateCreatedElement"] as? Date
        self.isAddedToCv = dictionary["isAddedToCv"] as? Bool
        self.isOpen = dictionary["isOpen"] as? Bool
        self.isThanks = dictionary["isThanks"] as? Bool
        self.review = dictionary["review"] as? String
        self.reviewID = dictionary["reviewID"] as? String
        self.timestampAddedCV = dictionary["timestampAddedCV"] as? Timestamp
        self.timestampCreation = dictionary["timestampCreation"] as? Timestamp

    }
}

