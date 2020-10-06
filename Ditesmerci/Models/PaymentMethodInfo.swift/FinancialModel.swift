//
//  FinancialMOdel.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 19/07/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import Foundation
import Firebase

class FinancialModel: NSObject {
    var action: String?
    var amount: Int?
    var executionDate: Timestamp?
    var executionDateString: String?
    
    init(dictionary: [AnyHashable: Any]) {
        self.action = dictionary["action"] as? String
        self.amount = dictionary["amount"] as? Int
        self.executionDate = dictionary["executionDate"] as? Timestamp
        self.executionDateString = dictionary["executionDateString"] as? String
    }
}
