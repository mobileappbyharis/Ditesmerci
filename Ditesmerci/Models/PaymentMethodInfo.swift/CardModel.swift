//
//  CardModel.swift
//  Ditesmerci
//
//  Created by 7k04 on 17/02/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

// need uppercase for variables for this one
class CardModel: NSObject {
    var active: Bool?
    var alias: String?
    var bankCode: String?
    var cardProvider: String?
    var cardType: String?
    var country: String?
    var creationDate: Date?
    var currency: String?
    var expirationDate: String?
    var fingerprint: String?
    var id: String?
    var product: String?
    var tag: String?
    var validity: String?
    var isDefault: Bool?




    init(dictionary: [AnyHashable: Any]) {
        self.active = dictionary["Active"] as? Bool
        self.alias = dictionary["Alias"] as? String
        self.bankCode = dictionary["BankCode"] as? String
        self.cardProvider = dictionary["CardProvider"] as? String
        self.cardType = dictionary["CardType"] as? String
        self.country = dictionary["Country"] as? String
        self.creationDate = dictionary["CreationDate"] as? Date
        self.currency = dictionary["Currency"] as? String
        self.expirationDate = dictionary["ExpirationDate"] as? String
        self.fingerprint = dictionary["Fingerprint"] as? String
        self.id = dictionary["Id"] as? String
        self.product = dictionary["Product"] as? String
        self.tag = dictionary["Tag"] as? String
        self.validity = dictionary["Validity"] as? String
        self.isDefault = dictionary["isDefault"] as? Bool

    }
}
