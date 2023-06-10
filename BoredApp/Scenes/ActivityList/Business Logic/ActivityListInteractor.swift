//
//  ActivityListInteractor.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import Foundation

final class ActivityListInteractor {

    private lazy var remoteLoader: RemoteActivityLoader = {
        let clientHTTP = ClientHTTP(session: URLSession.shared)
        return RemoteActivityLoader(clientHTTP: clientHTTP)
    }()

    private lazy var localStorage: CoreDataManager = {
        return AppDelegate.shared.coreDataManager
    }()
    
    private var activities: [ActivityCodable] = []
    
    func fetch(filters: [String] = [], _ completion: (([ActivityCodable]) -> ())?) {
        activities = localStorage.getUserActivities()
        
        guard activities.count == 0 else {
            completion?(activities)
            return
        }
        
        let group = DispatchGroup()

        for _ in 0...10 {
            group.enter()
            Task {
                let activity = try await remoteLoader.fetch(filters)
                activities.append(activity)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            completion?(self.activities)
        }
    }
}
