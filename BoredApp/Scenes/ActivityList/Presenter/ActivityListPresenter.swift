//
//  ActivityListPresenter.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 12/06/23.
//

import UIKit

final class ActivityListPresenter {
    
    weak var viewController: ActivityListViewController?
    
    func present(_ activity: ActivityModel, index: Int) {
        let item = map(activity)        
        viewController?.show(item, at: index)
    }
    
    func present(activities: [ActivityModel]) {
        
        var items: [ActivityItem] = []
        
        activities.forEach({ activity in
            let item = map(activity)
            items.append(item)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let self = self else { return }
            self.viewController?.show(items)
        })
    }
    
    func presentError() {        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let self = self else { return }
            self.viewController?.showError()
        })
    }
    
    private func map(_ activity: ActivityModel) -> ActivityItem {

        let activityType = "\(activity.type) activity"
      
        let priceLabel: String
        if activity.price <= 0.3 {
            priceLabel = "🤑 cost"
        } else if activity.price <= 6.9 {
            priceLabel = "🤑🤑 cost"
        } else {
            priceLabel = "🤑🤑🤑 cost"
        }
        
        let accessbilityLabel: String
        if activity.accessibility <= 0.3 {
            accessbilityLabel = "😋 easy"
        } else if activity.accessibility <= 0.6 {
            accessbilityLabel = "🧐 medium"
        } else {
            accessbilityLabel = "🥵 hard"
        }
        
        let participantLabel = String(activity.participants)
        var activityColor: UIColor

        if let type = ActivityType(rawValue: activity.type), let color = UIColor(hex: type.color) {
            activityColor = color
        } else {
            activityColor = .clear
        }
        
        var buttonTitle: String = ""
        var riskName: Bool = false
        var animateButton: Bool = true
        var disableButton: Bool = false
        var didStartActivity: Bool = false
        
        switch (activity.state) {
        case .pending:
            buttonTitle = "Finish"
            didStartActivity = true
            animateButton = true
        case .finished:
            buttonTitle = activity.endTime
            animateButton = false
            disableButton = true
            didStartActivity = true
        case .aborted:
            buttonTitle = activity.endTime
            animateButton = false
            riskName = true
            disableButton = true
            didStartActivity = true
        default:
            buttonTitle = "Start"
        }

        return ActivityItem(type: activityType,
                                name: activity.activity,
                                riskName: riskName,
                                accessbility: accessbilityLabel,
                                price: priceLabel,
                                buttonTitle: buttonTitle,
                                participants: participantLabel,
                                animateButton: animateButton,
                                titleButton: buttonTitle,
                                activityColor: activityColor,
                                didStartActivity: didStartActivity,
                                disableButton: disableButton)
    }
 }

struct ActivityItem {
    var type: String
    var name: String
    var riskName: Bool
    var accessbility: String
    var price: String
    var buttonTitle: String
    var participants: String
    var animateButton: Bool
    var titleButton: String
    var activityColor: UIColor
    var didStartActivity: Bool
    var disableButton: Bool
}
