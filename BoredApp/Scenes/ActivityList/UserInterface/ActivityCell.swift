//
//  ActivityCell.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import UIKit

protocol ActivityCellDelegate: AnyObject {
    
    func showAlert(_ alert: UIAlertController)
}

final class ActivityCell: UICollectionViewCell {

    static let identifier: String = String(describing: ActivityCell.self)
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var difficultyLoadingView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var typeLoadingView: UIView!
    @IBOutlet weak var priceLoadingView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var participantImageView: UIImageView!
    @IBOutlet weak var participantLoadingView: UIView!
    @IBOutlet weak var activityType: UILabel!

    weak var delegate: ActivityCellDelegate?
    
    private let interactor = ActivityInteractor()
    private var activity: ActivityCodable?
    private lazy var shimmeringViews: [UIView] = [
        nameContainerView,
        typeLoadingView,
        difficultyLoadingView,
        priceLoadingView,
        participantLoadingView
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .white
        
                
        actionButton.transparentStyle(title: "Start Now!", with: 12)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setRadiusAndShadow()
    }
    
    func starLoading() {
        participantImageView.isHidden = true
        backgroundColor = .white
        shimmeringViews.forEach({ view in
            view.backgroundColor = .lightGray
            view.alpha = 1
            view.startShimmeringAnimation()
        })
        
        nameLabel.text = nil
        activityType.text = nil
        priceLabel.text = nil
        difficultyLabel.text = nil
        participantLabel.text = nil
        containerView.backgroundColor = .white
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        guard let activity = self.activity else { return }
                
        actionButton.transparentStyle(title: "Finish", with: 12)
        
        guard interactor.state != nil else {
            interactor.start(activity: activity)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "Did you finish?", preferredStyle: .actionSheet)

        let actionFinished = UIAlertAction(title: "Yes! I finished", style: .default) { _ in
            self.interactor.finish()
            self.actionButton.finishedStyle(title: self.interactor.endTime)
            self.nameLabel.strikethroughText(activity.activity, size: 17)
            self.actionButton.layer.removeAllAnimations()
            self.setNeedsDisplay()
            self.setNeedsLayout()
        }
        
        let actionAbort = UIAlertAction(title: "No! I'm bored", style: .destructive) { _ in
            self.interactor.abort()
            self.actionButton.finishedStyle(title: self.interactor.endTime)
            self.nameLabel.strikethroughText(activity.activity, size: 17)
            self.actionButton.layer.removeAllAnimations()
            self.setNeedsDisplay()
            self.setNeedsLayout()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(actionFinished)
        alert.addAction(actionAbort)
        alert.addAction(cancelAction)
        delegate?.showAlert(alert)
    }
    
    func stopLoading() {
        shimmeringViews.forEach({ view in
            hideViewWithAnimation(view)
        })
    }
    
    func hideViewWithAnimation(_ view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0
        })
    }
    
    func configure(_ activity: ActivityCodable) {
        self.activity = activity
        stopLoading()
        nameLabel.text = activity.activity
        activityType.text = "\(activity.type) activity"
      
        if activity.price <= 0.3 {
            priceLabel.text = "🤑 cost"
        } else if activity.price <= 6.9 {
            priceLabel.text = "🤑🤑 cost"
        } else {
            priceLabel.text = "🤑🤑🤑 cost"
        }
        
        if activity.accessibility <= 0.3 {
            difficultyLabel.text = "😋 easy"
        } else if activity.accessibility <= 0.6 {
            difficultyLabel.text = "🧐 medium"
        } else {
            difficultyLabel.text = "🥵 hard"
        }
        
        participantLabel.text = String(activity.participants)
        participantImageView.image = UIImage(named: "participant")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        participantImageView.isHidden = false
        
        if let type = ActivityType(rawValue: activity.type), let color = UIColor(hex: type.color) {
            UIView.animate(withDuration: 1, animations: {
                self.containerView.backgroundColor = color
                self.activityType.textColor = color
            })
        }
        
        blinkActionButton()
        interactor.load(activity: activity)

        if interactor.state == .pending {
            actionButton.transparentStyle(title: "Finish", with: 12)
        } else if interactor.state == .finished || interactor.state == .aborted {
            actionButton.layer.removeAllAnimations()
            actionButton.finishedStyle(title: interactor.endTime)
            nameLabel.strikethroughText(activity.activity, size: 17)
        }
    }
    
    func blinkActionButton() {
        actionButton.alpha = 0.2
        UIView.animate(
            withDuration: 1,
            delay: 0.0,
            options: [.curveLinear, .repeat, .autoreverse, .allowUserInteraction],
            animations: {
                self.actionButton.alpha = 1.0
            }
        )
    }
}
