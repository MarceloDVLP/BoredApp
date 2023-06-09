//
//  ActivityCodable.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import Foundation

struct ActivityCodable: Codable {    
    let activity: String
    let accessibility: Double
    let type: String
    let participants: Int
    let price: Double
    let key: String
    let link: String?
}
