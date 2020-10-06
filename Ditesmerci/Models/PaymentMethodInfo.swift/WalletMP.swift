//
//  WalletMP.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 24/07/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import Foundation

// MARK: - Welcome
class WalletMP: Codable {
    let Description: String
    let owners: [String]
    let balance: Balance
    let currency, fundsType, id, tag: String
    let creationDate: Double

    enum CodingKeys: String, CodingKey {
        case Description = "Description"
        case owners = "Owners"
        case balance = "Balance"
        case currency = "Currency"
        case fundsType = "FundsType"
        case id = "Id"
        case tag = "Tag"
        case creationDate = "CreationDate"
    }

    init(Description: String, owners: [String], balance: Balance, currency: String, fundsType: String, id: String, tag: String, creationDate: Double) {
        self.Description = Description
        self.owners = owners
        self.balance = balance
        self.currency = currency
        self.fundsType = fundsType
        self.id = id
        self.tag = tag
        self.creationDate = creationDate
    }
}

// MARK: - Balance
class Balance: Codable {
    let currency: String
    let amount: Int

    enum CodingKeys: String, CodingKey {
        case currency = "Currency"
        case amount = "Amount"
    }

    init(currency: String, amount: Int) {
        self.currency = currency
        self.amount = amount
    }
}
