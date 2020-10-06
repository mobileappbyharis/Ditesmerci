//
//  JobModel.swift
//  Ditesmerci
//
//  Created by 7k04 on 19/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class JobInfo: NSObject {
    var job: String?
    var jobCompanyName: String?
    var jobFormattedAddress: String?
    var jobPlaceId: String?
    var jobSector: String?
    var reviewNumber: Int?
    var thanks: Int?
    var timestampBegin: Timestamp?
    var timestampEnd: Timestamp?
    var timestampYearString: String?
    var timestampString: String?

    
    
    init(dictionary: [AnyHashable: Any]) {
        self.job = dictionary["job"] as? String
        self.jobCompanyName = dictionary["jobCompanyName"] as? String
        self.jobFormattedAddress = dictionary["jobFormattedAddress"] as? String
        self.jobPlaceId = dictionary["jobPlaceId"] as? String
        self.jobSector = dictionary["jobSector"] as? String
        self.reviewNumber = dictionary["reviewNumber"] as? Int
        self.thanks = dictionary["thanks"] as? Int
        self.timestampBegin = dictionary["timestampBegin"] as? Timestamp
        self.timestampEnd = dictionary["timestampEnd"] as? Timestamp
        self.timestampYearString = dictionary["timestampYearString"] as? String
        self.timestampString = dictionary["timestampString"] as? String

    }
}
