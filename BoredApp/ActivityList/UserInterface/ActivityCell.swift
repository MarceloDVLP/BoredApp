//
//  ActivityCell.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import UIKit

final class ActivityCell: UICollectionViewCell {

    static let identifier: String = String(describing: ActivityCell.self)
    var cornerRadius: CGFloat = 12
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

    lazy var shimmeringViews: [UIView] = [
        nameContainerView,
        typeLoadingView,
        difficultyLoadingView,
        priceLoadingView,
        participantLoadingView
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .white
        
        
        let image = UIImage(named: "start")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        actionButton.setImage(image, for: .normal)
        actionButton.setImage(nil, for: .highlighted)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setRadiusAndShadow()
    }
    
    func starLoading() {
        participantImageView.isHidden = true
        shimmeringViews.forEach({ view in
            view.backgroundColor = .lightGray
            view.startShimmeringAnimation()
        })
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
    }
}
