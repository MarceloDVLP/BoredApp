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
    
    func start(activity: ActivityCodable) {
        localStorage.save(activity)
    }
}
