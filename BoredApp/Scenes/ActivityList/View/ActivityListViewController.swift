//
//  ViewController.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import UIKit

final class ActivityListViewController: UIViewController {

    private var interactor: ActivityListInteractor
    private var router: ActivityListRouter

    private lazy var activityListView: ActivityListView = {
        return ActivityListView()
    }()    
        
    init(interactor: ActivityListInteractor, router: ActivityListRouter) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        super.loadView()
        activityListView.delegate = self
        view = activityListView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Never Bored!"
        view.backgroundColor = Colors.backGroundColor
        fetch()
    }
}

extension ActivityListViewController {

    func didTapFilter() {        
        router.routeToFilter() { [weak self] activityType in
            guard let self = self else { return }
            self.fetch(activityType: activityType)
        }
    }
    
    func didTapMyActivities(_ isSelected: Bool) {
        fetch(userActivities: isSelected, activityType: nil)
    }
    
    func userDidTapActivity(_ activity: ActivityModel, _ index: Int, cell: ActivityCell) {
        if activity.state != nil {
            showAlert(for: index, cell: cell)
        } else {
            interactor.start(at: index)
        }
    }
    
    func fetch(userActivities: Bool = false, activityType: String? = nil) {
        activityListView.showLoading()
        interactor.fetch(activityType: activityType,
                         userActivities: userActivities)        
    }
}

extension ActivityListViewController {
        
    func showAlert(for index: Int, cell: ActivityCell) {
        let alert = UIAlertController(title: nil, message: "Did you finish?", preferredStyle: .actionSheet)

        let actionFinished = UIAlertAction(title: "Yes! I finished", style: .default) { _ in
            self.setActivityState(state: .finished,
                             at: index,
                             cell)
        }
        
        let actionAbort = UIAlertAction(title: "No! I'm bored", style: .destructive) { _ in
            self.setActivityState(state: .aborted,
                             at: index,
                             cell)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(actionFinished)
        alert.addAction(actionAbort)
        alert.addAction(cancelAction)
        
        router.show(alert: alert)
    }
    
    func setActivityState(state: ActivityState, at index: Int, _ cell: ActivityCell) {
        interactor.setState(state: state, for: index)
        cell.update(activity: interactor.activity(for: index))
    }
}

extension ActivityListViewController {
    
    func show(_ activities: [ActivityModel]) {
        activityListView.show(activities: activities)
    }
    
    func showError() {
        activityListView.showError()
    }
}
