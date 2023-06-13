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
        
        
        actionButton.transparentStyle(title: "", with: 12)
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
    
    func update(activity: ActivityItem) {
        setupButton(with: activity.buttonTitle,
                    animateButton: activity.animateButton,
                    disableButton: activity.disableButton)
        
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
    
    func configure(_ activity: ActivityItem?) {
        guard let activity = activity else { return }
        stopLoading()

        activityType.text = activity.type
        priceLabel.text = activity.price
        difficultyLabel.text = activity.accessbility
        participantLabel.text = activity.participants
        
        setupParticipantImage()
        setupColor(with: activity.activityColor)
        setupName(with: activity.name)
        setupButton(with: activity.buttonTitle, animateButton: activity.animateButton, disableButton: activity.disableButton)
        
        activity.riskName ? nameLabel.strikethroughText(activity.name, size: 17) : ()
    }
    
    private func setupName(with title: String) {
        nameLabel.attributedText = nil
        nameLabel.text = title
    }
    
    private func setupButton(with title: String, animateButton: Bool, disableButton: Bool) {
        actionButton.isHidden = false
        actionButton.isUserInteractionEnabled = !disableButton

        if animateButton {
            actionButton.transparentStyle(title: title, with: 12)
            blinkActionButton()
        } else {
            actionButton.layer.removeAllAnimations()
            actionButton.finishedStyle(title: title)
        }
    }
    
    private func setupColor(with color: UIColor) {
        UIView.animate(withDuration: 1, animations: {
            self.containerView.backgroundColor = color
            self.activityType.textColor = color
        })
    }
    
    private func setupParticipantImage() {
        participantImageView.image = UIImage(named: "participant")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        participantImageView.isHidden = false
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
