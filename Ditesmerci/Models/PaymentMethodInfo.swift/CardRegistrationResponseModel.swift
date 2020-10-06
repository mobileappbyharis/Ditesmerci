//
//  CardRegistrationResponseModel.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 06/05/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cardRegistrationResponseModel = try? newJSONDecoder().decode(CardRegistrationResponseModel.self, from: jsonData)

import Foundation

class CardRegistrationResponseModel: NSObject {
    var id, tag, creationDate, userID, accessKey, preregistrationData, registrationData, cardID, cardType, cardRegistrationURL, resultCode, resultMessage, currency, status  : String?
    
    init(dictionary: [AnyHashable: Any]) {
        self.id = dictionary["Id"] as? String
        self.tag = dictionary["Tag"] as? String
        self.creationDate = dictionary["CreationDate"] as? String
        self.userID = dictionary["UserId"] as? String
        self.accessKey = dictionary["AccessKey"] as? String
        self.preregistrationData = dictionary["PreregistrationData"] as? String
        self.registrationData = dictionary["RegistrationData"] as? String
        self.cardID = dictionary["CardId"] as? String
        self.cardType = dictionary["CardType"] as? String
        self.cardRegistrationURL = dictionary["CardRegistrationURL"] as? String
        self.resultCode = dictionary["ResultCode"] as? String
        self.resultMessage = dictionary["ResultMessage"] as? String
        self.currency = dictionary["Currency"] as? String
        self.status = dictionary["Status"] as? String

    }
}
