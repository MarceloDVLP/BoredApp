//
//  ActivityListInteractor.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import Foundation

final class ActivityListInteractor {

    private var remoteWorker: RemoteActivityWorker
    private var localWorker: CoreDataWorker
    private var presenter: ActivityListPresenter
    
    init(remoteWorker: RemoteActivityWorker, localWorker: CoreDataWorker, presenter: ActivityListPresenter) {
        self.remoteWorker = remoteWorker
        self.localWorker = localWorker
        self.presenter = presenter
    }
    
    private var activities: [ActivityModel] = []
    
    func fetch(activityType: String?,
               userActivities: Bool = false) {
        
        activities = []
        
        guard userActivities else {
            self.fetchFromRemote(activityType: activityType) { result in
                self.presenter.present(activities: result)
            }
            return
        }
        
        localWorker.getUserActivities() { [weak self] result in
            guard let self = self else { return }
            self.activities = result
            
            self.fetchFromRemote(activityType: activityType) { result in
                DispatchQueue.main.async {
                    self.presenter.present(activities: result)
                }
            }
        }
    }
    
    func fetchFromRemote(activityType: String?, _ completion: (([ActivityModel]) -> ())?) {
        let group = DispatchGroup()
        
        for _ in 0...10 {
            group.enter()
            
            Task {
                let result = try await remoteWorker.fetch(activityType)
                
                switch (result) {
                case .success(let activity):
                    activities.append(ActivityModel(activityCodable: activity))
                case .failure:
                    break
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            completion?(self.activities)
        }
    }
    
    func start(at index: Int) {
        let activity = activities[index]
        
        if activity.state == nil {
            let dateStart = Date.now
            activity.dateStart = dateStart
            activity.state = .pending
            localWorker.save(activity, state: .pending, date: dateStart)
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
        localWorker.update(activity, state: state, date: dateEnd)
    }
    
    func activity(for index: Int) -> ActivityModel {
        return activities[index]
    }
}
