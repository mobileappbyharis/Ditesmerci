//
//  MerciInfo.swift
//  Ditesmerci
//
//  Created by 7k04 on 20/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class MerciInfo: NSObject {
    var clientFirstName: String?
    var clientProfileImageUrl: String?
    var clientUid: String?
    var isPourboire: Bool?
    var isReviewVisible: Bool?
    var isThanked: Bool?
    var jobPlaceId: String?
    var reviewsIDs: [String]?
    var timestampCreation: Timestamp?
    var timestampModification: Timestamp?

    
    
    init(dictionary: [AnyHashable: Any]) {
        self.clientFirstName = dictionary["clientFirstName"] as? String
        self.clientProfileImageUrl = dictionary["clientProfileImageUrl"] as? String
        self.clientUid = dictionary["clientUid"] as? String
        self.isPourboire = dictionary["isPourboire"] as? Bool
        self.isReviewVisible = dictionary["isReviewVisible"] as? Bool
        self.isThanked = dictionary["isThanked"] as? Bool
        self.jobPlaceId = dictionary["jobPlaceId"] as? String
        self.reviewsIDs = dictionary["reviewsIDs"] as? [String]
        self.timestampCreation = dictionary["timestampCreation"] as? Timestamp
        self.timestampModification = dictionary["timestampModification"] as? Timestamp
    }
}
