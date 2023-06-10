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

enum ActivityType: String, CaseIterable {
    case education
    case recreational
    case social
    case diy
    case charity
    case cooking
    case relaxation
    case music
    case busywork
    case none
    
    var color: String {
        switch self {
        case .education:
            return "#EB9E9A"
        case .recreational:
            return "#E0C6AF"
        case .social:
            return "#B0DAC1"
        case .diy:
            return "#E59CBA"
        case .charity:
            return "#C4C7A4"
        case .cooking:
            return "#165AA1"
        case .relaxation:
            return "#71A9E3"
        case .music:
            return "#7C2D4A"
        case .busywork:
            return "#29AEC0"
        case .none:
            return "#CCBE9A"
        }
    }
}

