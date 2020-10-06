//
//  DocumentKYCMP.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 20/07/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//

import Foundation

struct DocumentKYCMP: Codable {
    var `Type`: String?
    var UserId: String?
    var Id: String?
    var Tag: String?
    var ProcessedDate: Double?
    var Status: String?
    var RefusedReasonType: String?
    var RefusedReasonMessage: String?
}

extension DocumentKYCMP {
    enum CodingKeys: String, CodingKey {
        case `Type`
        case UserId
        case Id
        case Tag
        case ProcessedDate
        case Status
        case RefusedReasonType
        case RefusedReasonMessage
    }
}
