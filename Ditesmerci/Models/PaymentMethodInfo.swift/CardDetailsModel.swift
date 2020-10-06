//
//  CardDetails.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 08/05/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

//   let cardDetailsModel = try? newJSONDecoder().decode(CardDetailsModel.self, from: jsonData)

import Foundation

// MARK: - CardDetailsModel
class CardDetailsModel: Codable {
    let accessKeyRef, data, cardNumber, cardExpirationDate: String
    let cardCvx: String

    init(accessKeyRef: String, data: String, cardNumber: String, cardExpirationDate: String, cardCvx: String) {
        self.accessKeyRef = accessKeyRef
        self.data = data
        self.cardNumber = cardNumber
        self.cardExpirationDate = cardExpirationDate
        self.cardCvx = cardCvx
    }
}
