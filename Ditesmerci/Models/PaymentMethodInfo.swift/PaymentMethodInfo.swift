//
//  SourceModel.swift
//  Ditesmerci
//
//  Created by 7k04 on 17/02/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class PaymentMethodInfo: NSObject {
    var card: CardModel?
    var created: Int?
    var customer: String?
    var id: String?
    var livemode: Bool?
    var object: String?
    var type: String?
    
    init(dictionary: [AnyHashable: Any]) {
        self.card = dictionary["card"] as? CardModel
        self.created = dictionary["created"] as? Int
        self.customer = dictionary["customer"] as? String
        self.id = dictionary["id"] as? String
        self.livemode = dictionary["livemode"] as? Bool
        self.object = dictionary["object"] as? String
        self.type = dictionary["type"] as? String

    }
}
