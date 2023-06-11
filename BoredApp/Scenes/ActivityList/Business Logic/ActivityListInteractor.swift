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
    
    private var activities: [ActivityModel] = []
    
    func fetch(filters: [String] = [], _ completion: (([ActivityModel]) -> ())?) {
        activities = []//
        
        localStorage.getUserActivities() { [weak self] result in
            guard let self = self else { return }
            
            guard result.count == 0 else {
                self.activities = result

                DispatchQueue.main.async {
                    completion?(result)
                }
                return
            }

            self.fetchFromRemote(filters: filters) { result in
                DispatchQueue.main.async {
                    completion?(result)
                }
            }
        }
    }
    
    func fetchFromRemote(filters: [String] = [], _ completion: (([ActivityModel]) -> ())?) {
        let group = DispatchGroup()

        for _ in 0...10 {
            group.enter()
            Task {
                let activity = try await remoteLoader.fetch(filters)
                activities.append(ActivityModel(activityCodable: activity))
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            completion?(self?.activities ?? [])
        }
    }
    
    func start(at index: Int) {
        let activity = activities[index]
        
        if activity.state == nil {
            let dateStart = Date.now
            activity.dateStart = dateStart
            activity.state = .pending
            localStorage.save(activity, state: .pending, date: dateStart)
        }
    }
    
    func isActivityStarted(at index: Int) -> Bool {
        let activity = activities[index]
        return activity.state != nil
    }
    
    func setState(state: ActivityState, for activityIndex: Int) {
        let activity = activities[activityIndex]
        activity.state = state
        let dateEnd = Date.now
        activity.dateEnd = dateEnd
        localStorage.update(activity, state: state, date: dateEnd)
    }
    
    func activity(for index: Int) -> ActivityModel {
        return activities[index]
    }
}
