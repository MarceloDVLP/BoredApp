//
//  ActivityCell.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import UIKit

protocol ActivityCellDelegate: AnyObject {
    
    func userDidTapButton(at cell: ActivityCell)
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
        containerView.backgroundColor = .lightGray
        
                
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
        actionButton.isHidden = true
        containerView.backgroundColor = .darkGray.withAlphaComponent(0.7)
    }
    
    func update(activity: ActivityModel) {
        actionButton.finishedStyle(title: activity.endTime)
        actionButton.layer.removeAllAnimations()
        actionButton.isHidden = false
        actionButton.isUserInteractionEnabled = false
        nameLabel.strikethroughText(activity.activity, size: 17)
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        actionButton.transparentStyle(title: "Finish", with: 12)
        delegate?.userDidTapButton(at: self)
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
    
    func configure(_ activity: ActivityModel) {
        stopLoading()
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
        actionButton.isHidden = false
        setupName(with: activity.activity)
        actionButton.isUserInteractionEnabled = true

        if activity.state == .pending {
            actionButton.transparentStyle(title: "Finish", with: 12)
            blinkActionButton()
        } else if activity.state == .finished || activity.state == .aborted {
            actionButton.layer.removeAllAnimations()
            actionButton.finishedStyle(title: activity.endTime)
            actionButton.isUserInteractionEnabled = false
            nameLabel.strikethroughText(activity.activity, size: 17)
        }
    }
    
    private func setupName(with title: String) {
        nameLabel.attributedText = nil
        nameLabel.text = title
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
