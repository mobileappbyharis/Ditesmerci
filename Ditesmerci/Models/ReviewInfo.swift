//
//  ReviewInfo.swift
//  Ditesmerci
//
//  Created by 7k04 on 20/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class ReviewInfo: NSObject {
    var clientFirstName: String?
    var clientProfileImageUrl: String?
    var clientUid: String?
    var isAddedToCv: Bool?
    var isOpen: Bool?
    var isReviewVisible: Bool?
    var jobPlaceId: String?
    var review: String?
    var timestampAddedToCv: Timestamp?
    var timestampCreation: Timestamp?
    var timestampModification: Timestamp?
    
    
    init(dictionary: [AnyHashable: Any]) {
        self.clientFirstName = dictionary["clientFirstName"] as? String
        self.clientProfileImageUrl = dictionary["clientProfileImageUrl"] as? String
        self.clientUid = dictionary["clientUid"] as? String
        self.isAddedToCv = dictionary["isAddedToCv"] as? Bool
        self.isOpen = dictionary["isOpen"] as? Bool
        self.isReviewVisible = dictionary["isReviewVisible"] as? Bool
        self.jobPlaceId = dictionary["jobPlaceId"] as? String
        self.review = dictionary["review"] as? String
        self.timestampAddedToCv = dictionary["timestampAddedToCv"] as? Timestamp
        self.timestampCreation = dictionary["timestampCreation"] as? Timestamp
        self.timestampModification = dictionary["timestampModification"] as? Timestamp
    }
}
