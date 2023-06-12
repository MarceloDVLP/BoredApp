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

class ActivityModel {
    var activity: String
    var accessibility: Double
    var type: String
    var participants: Int
    var price: Double
    var key: String
    var state: ActivityState?
    var dateStart: Date?
    var dateEnd: Date?
    
    init(activity: String, accessibility: Double, type: String, participants: Int, price: Double, key: String, state: ActivityState?, dateStart: Date? = nil, dateEnd: Date? = nil) {
        self.activity = activity
        self.accessibility = accessibility
        self.type = type
        self.participants = participants
        self.price = price
        self.key = key
        self.state = state
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }
    
    init(activityCodable: ActivityCodable) {
        self.activity = activityCodable.activity
        self.accessibility = activityCodable.accessibility
        self.type = activityCodable.type
        self.participants = activityCodable.participants
        self.price = activityCodable.price
        self.key = activityCodable.key
        self.state = nil
        self.dateStart = nil
        self.dateEnd = nil
    }
    
    var endTime: String {
        guard let dateStart = dateStart, let dateEnd = dateEnd else { return "" }
    
        let dateDiff = Calendar.current.dateComponents([.day, .minute, .hour, .second], from: dateStart, to: dateEnd)
        
        if let value = dateDiff.minute, value > 0 {
            return "\(state?.rawValue ?? "") in \(value) minutes"
        }

        if let value = dateDiff.hour, value > 0 {
            return "\(state?.rawValue ?? "") in \(value) hours"
        }

        if let value = dateDiff.day, value > 0 {
            return "\(state?.rawValue ?? "") in \(value) days"
        }
        
        if let value = dateDiff.second, value > 0 {
            return "\(state?.rawValue ?? "") in \(value) seconds"
        }
        
        return "\(state?.rawValue ?? "")"
    }
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

enum ActivityState: String {
    case pending
    case finished
    case aborted
}
