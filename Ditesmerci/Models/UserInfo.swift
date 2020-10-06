//
//  UserInfo.swift
//  Ditesmerci
//
//  Created by 7k04 on 11/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import Firebase
import FirebaseFirestore

class UserInfo: NSObject {
    var amountPourboire: Double?
    var birthdate: String?
    var email: String?
    var firstName: String?
    var firstNameLowercase: String?
    var gpsLastLocation: GeoPoint?
    var isConnected: Bool?
    var isHistoric: Bool?
    var isPresent: Bool?
    var isPro: Bool?
    var isShowcase: Bool?
    var job: String?
    var jobCompanyName: String?
    var jobFormattedAddress: String?
    var jobGpsLocation: GeoPoint?
    var jobGpsRadius: String?
    var jobPlaceId: String?
    var jobSector: String?
    var lastName: String?
    var lastNameLowercase: String?
    var notificationTokens: String?
    var phoneNumber: String?
    var profileImageUrl: String?
    var profileImageUrlThumbnail: String?
    var reviewNumber: Int?
    var thanks: Int?
    var timestampCreationAccount: Timestamp?
    var timestampLastGpsDetection: Timestamp?
    var timestampModification: Timestamp?
    var timestampPresent: Timestamp?
    var timestampVisited: Timestamp?
    var uid: String?
    var uidLinkedin: String?
    
    init(dictionary: [AnyHashable: Any]) {
        self.amountPourboire = dictionary["amountPourboire"] as? Double
        self.birthdate = dictionary["birthdate"] as? String
        self.email = dictionary["email"] as? String
        self.firstName = dictionary["firstName"] as? String
        self.firstNameLowercase = dictionary["firstNameLowercase"] as? String
        self.gpsLastLocation = dictionary["gpsLastLocation"] as? GeoPoint
        self.isConnected = dictionary["isConnected"] as? Bool
        self.isHistoric = dictionary["isHistoric"] as? Bool
        self.isPresent = dictionary["isPresent"] as? Bool
        self.isPro = dictionary["isPro"] as? Bool
        self.isShowcase = dictionary["isShowcase"] as? Bool
        self.job = dictionary["job"] as? String
        self.jobCompanyName = dictionary["jobCompanyName"] as? String
        self.jobFormattedAddress = dictionary["jobFormattedAddress"] as? String
        self.jobGpsLocation = dictionary["jobGpsLocation"] as? GeoPoint
        self.jobGpsRadius = dictionary["jobGpsRadius"] as? String
        self.jobPlaceId = dictionary["jobPlaceId"] as? String
        self.jobSector = dictionary["jobSector"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.lastNameLowercase = dictionary["lastNameLowercase"] as? String
        self.notificationTokens = dictionary["notificationTokens"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.profileImageUrlThumbnail = dictionary["profileImageUrlThumbnail"] as? String
        self.reviewNumber = dictionary["reviewNumber"] as? Int
        self.thanks = dictionary["thanks"] as? Int
        self.timestampCreationAccount = dictionary["timestampCreationAccount"] as? Timestamp
        self.timestampLastGpsDetection = dictionary["timestampLastGpsDetection"] as? Timestamp
        self.timestampModification = dictionary["timestampModification"] as? Timestamp
        self.timestampPresent = dictionary["timestampPresent"] as? Timestamp
        self.timestampVisited = dictionary["timestampVisited"] as? Timestamp
        self.uid = dictionary["uid"] as? String
        self.uidLinkedin = dictionary["uidLinkedin"] as? String
    }
}

