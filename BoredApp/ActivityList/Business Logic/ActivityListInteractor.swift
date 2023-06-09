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
    
    var activities: [ActivityCodable] = []
        
    func fetch(_ completion: (([ActivityCodable]) -> ())?) {
        let group = DispatchGroup()

        for _ in 0...6 {
            group.enter()
            Task {
                let activity = try await remoteLoader.fetch()
                activities.append(activity)
                //group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            completion?(self.activities)
        }
    }
}
