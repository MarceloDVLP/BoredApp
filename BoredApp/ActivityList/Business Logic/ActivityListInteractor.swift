//
//  ActivityListInteractor.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import Foundation
import CoreData

final class ActivityListInteractor {

    private lazy var remoteLoader: RemoteActivityLoader = {
        let clientHTTP = ClientHTTP(session: URLSession.shared)
        return RemoteActivityLoader(clientHTTP: clientHTTP)
    }()
    
    var activities: [ActivityCodable] = []
    
    func fetch(filters: [String] = [], _ completion: (([ActivityCodable]) -> ())?) {
        activities = getUserActivities()
        
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
    
    func getUserActivities() -> [ActivityCodable] {
        let itemsFetch: NSFetchRequest<ActivityEntity> = ActivityEntity.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(ActivityEntity.dateStart), ascending: false)
        itemsFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.shared.coreDataManager.managedContext
            let results = try managedContext.fetch(itemsFetch)
            return results.map({ result in
                ActivityCodable(
                    activity: result.activity,
                    accessibility: result.accessibility,
                    type: result.type,
                    participants: Int(result.participants),
                    price: result.price,
                    key: result.key,
                    link: nil)
            })
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return []
        }
    }
}
