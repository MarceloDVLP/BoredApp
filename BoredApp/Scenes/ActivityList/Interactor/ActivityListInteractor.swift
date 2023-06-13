//
//  ActivityListInteractor.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import Foundation

protocol ActivityListInteractorProtocol {
    func fetch(activityType: String?, userActivities: Bool)
    func start(at index: Int)
    func setState(state: ActivityState, for activityIndex: Int)
}


final class ActivityListInteractor: ActivityListInteractorProtocol {

    private var remoteWorker: RemoteActivityWorkerProtocol
    private var localWorker: CoreDataWorkerProtocol
    private var presenter: ActivityListPresenterProtocol
    
    init(remoteWorker: RemoteActivityWorkerProtocol,
         localWorker: CoreDataWorkerProtocol,
         presenter: ActivityListPresenterProtocol) {
        self.remoteWorker = remoteWorker
        self.localWorker = localWorker
        self.presenter = presenter
    }
    
    private var activities: [ActivityModel] = []
    
    func fetch(activityType: String?, userActivities: Bool = false) {
        activities = []

        guard userActivities else {
            self.fetchFromRemote(activityType: activityType) { [weak self] result in
                self?.activities = result
                result.isEmpty ?
                self?.presenter.presentError() :
                self?.presenter.present(activities: result)
            }
            return
        }
        
        localWorker.getUserActivities() { [weak self] result in
            guard let self = self else { return }
            self.presenter.present(activities: result)
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
        
        presenter.present(activity, index: index)
    }
    
    func setState(state: ActivityState, for activityIndex: Int) {
        let activity = activities[activityIndex]
        activity.state = state
        let dateEnd = Date.now
        activity.dateEnd = dateEnd
        localWorker.update(activity, state: state, date: dateEnd)
        presenter.present(activity, index: activityIndex)
    }
    
    private func fetchFromRemote(activityType: String?, _ completion: (([ActivityModel]) -> ())?) {
        let group = DispatchGroup()
        
        var filter: String?
        if let type = activityType, let filterType = ActivityType(rawValue: type), filterType == .none {
            filter = nil
        } else {
            filter = activityType
        }
        
        for _ in 0...10 {
            group.enter()
            
            Task { [filter] in
                do {
                    let result = try await remoteWorker.fetch(filter)

                    switch (result) {
                    case .success(let activity):
                        activities.append(ActivityModel(activityCodable: activity))
                        group.leave()
                    case .failure:
                        break
                    }
                    
                } catch {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            completion?(self.activities)
        }
    }
}
