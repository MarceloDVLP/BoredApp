//
//  ActivityListPresenter.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 12/06/23.
//

import Foundation

final class ActivityListPresenter {
    
    weak var viewController: ActivityListViewController?
    
    func present(activities: [ActivityModel]) {
        viewController?.show(activities)
    }
    
    func presentError() {
        
    }
}
