//
//  RegistrationData.swift
//  Ditesmerci
//
//  Created by Haris Haouassi on 08/05/2020.
//  Copyright © 2020 mobileappbyharis. All rights reserved.
//   

import Foundation

// MARK: - RegistrationDataModel
struct RegistrationDataModel: Codable {
    let registrationData: String

    enum CodingKeys: String, CodingKey {
        case registrationData = "RegistrationData"
    }
}
