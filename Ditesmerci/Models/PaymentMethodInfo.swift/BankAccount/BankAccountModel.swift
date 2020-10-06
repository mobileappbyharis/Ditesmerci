//
//  BankAccountModel.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 01/06/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class BankAccountModel: NSObject {
    var iban, ownerName, type, id, tag: String?
    var isDefault, isActive: Bool?
    
    init(dictionary: [AnyHashable: Any]) {
        self.iban = dictionary["iban"] as? String
        self.id = dictionary["id"] as? String
        self.isActive = dictionary["isActive"] as? Bool
        self.isDefault = dictionary["isDefault"] as? Bool
        self.ownerName = dictionary["ownerName"] as? String
        self.tag = dictionary["tag"] as? String
        self.type = dictionary["type"] as? String
    }
}
