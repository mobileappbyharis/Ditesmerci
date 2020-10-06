//
//  CustomerMP.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 20/07/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import Foundation

class CustomerMP: NSObject {
    var mango_id: String?
    var wallet_id: String?
    var documentKYC_id: String?


    init(dictionary: [AnyHashable: Any]) {
        self.mango_id = dictionary["mango_id"] as? String
        self.wallet_id = dictionary["wallet_id"] as? String
        self.documentKYC_id = dictionary["documentKYC_id"] as? String

    }
}
