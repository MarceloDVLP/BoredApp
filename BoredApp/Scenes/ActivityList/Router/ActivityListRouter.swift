//
//  ActivityListRouter.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 12/06/23.
//

import UIKit

final class ActivityListRouter {
    
    weak var viewController: ActivityListViewController?
    
    func routeToFilter(completion: ((String) -> ())?) {
        let items = ActivityType.allCases.map({ $0.rawValue })
        let filterViewController = FilterViewController(items: items, selectedIndex: -1)

        filterViewController.didSelectItem = { selected in
            completion?(selected)
        }
        
        viewController?.present(filterViewController, animated: true)
    }
    
    func show(alert: UIAlertController) {
        viewController?.present(alert, animated: true)
    }
}
