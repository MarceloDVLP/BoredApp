//
//  ActivityListFactory.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 12/06/23.
//

import Foundation

final class ActivityListFactory {
    
    static func make() -> ActivityListViewController {
        let session = URLSession.shared
        let client = ClientHTTP(session: session)
        let remoteWorker = RemoteActivityWorker(clientHTTP: client)
        
        let localWorker = CoreDataWorker()

        let presenter = ActivityListPresenter()

        let interactor = ActivityListInteractor(remoteWorker: remoteWorker,
                                                localWorker: localWorker,
                                                presenter: presenter)
        
        let router = ActivityListRouter()
        
        let viewController = ActivityListViewController(interactor: interactor, router: router)
        
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
