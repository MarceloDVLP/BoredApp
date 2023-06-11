//
//  ActivityInteractor.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 10/06/23.
//

import Foundation

final class ActivityInteractor {
        
    private var activityEntity: ActivityEntity?
    
    private lazy var localStorage: CoreDataManager = {
        return AppDelegate.shared.coreDataManager
    }()
    
    func load(activity: ActivityCodable) {
        self.activityEntity = localStorage.get(key: activity.key)
    }
    
    func start(activity: ActivityCodable) {
        if let entity = activityEntity {
            entity.state = ActivityState.pending.rawValue
            localStorage.saveContext()
        } else {
            self.activityEntity = localStorage.save(activity, state: .pending)
        }
    }
    
    func finish() {
        activityEntity?.state = ActivityState.finished.rawValue
        activityEntity?.dateEnd = Date.now
        localStorage.saveContext()
    }
    
    func abort() {
        activityEntity?.state = ActivityState.aborted.rawValue
        activityEntity?.dateEnd = Date.now
        localStorage.saveContext()
    }
    
    var state: ActivityState? {
        return ActivityState(rawValue: activityEntity?.state ?? "")
    }
    
    var endTime: String {
        guard let dateStart = activityEntity?.dateStart, let dateEnd = activityEntity?.dateEnd else { return "" }
    
        let dateDiff = Calendar.current.dateComponents([.day, .minute, .hour, .second], from: dateStart, to: dateEnd)
        
        if let value = dateDiff.minute, value > 0 {
            return "\(activityEntity?.state ?? "") in \(value) minutes"
        }

        if let value = dateDiff.hour, value > 0 {
            return "\(activityEntity?.state ?? "") in \(value) hours"
        }

        if let value = dateDiff.day, value > 0 {
            return "\(activityEntity?.state ?? "") in \(value) days"
        }
        
        if let value = dateDiff.second, value > 0 {
            return "\(activityEntity?.state ?? "") in \(value) seconds"
        }
        
        return "\(activityEntity?.state ?? "")"
    }
}
            
enum ActivityState: String {
    case pending
    case finished
    case aborted
}

