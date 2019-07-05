//
//  DHT.swift
//  testKafka
//
//  Created by Mateo Doslic on 05/07/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation

// MARK: - DTIObject
struct DTIObject: Codable {
    let dti: Dti
    
    enum CodingKeys: String, CodingKey {
        case dti = "DTI"
    }
}

// MARK: - Dti
struct Dti: Codable {
    let humidity, temperatureC: Int
    let temperatureF: Double
}
