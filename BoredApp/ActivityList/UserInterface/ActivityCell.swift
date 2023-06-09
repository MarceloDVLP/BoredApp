//
//  ActivityCell.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import UIKit

final class ActivityCell: UICollectionViewCell {

    static let identifier: String = String(describing: ActivityCell.self)
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var activityType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 12
        
        let image = UIImage(named: "start")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        actionButton.setImage(image, for: .normal)
        actionButton.setImage(nil, for: .highlighted)
    }
    
    func configure(_ activity: ActivityCodable) {
        nameLabel.text = activity.activity
        activityType.text = activity.type
        if activity.price <= 0.3 {
            priceLabel.text = "low price"
        } else if activity.price <= 6.9 {
            priceLabel.text = "good price"
        } else {
            priceLabel.text = "high price"
        }
        
        if activity.accessibility <= 0.3 {
            difficultyLabel.text = "😋 easy"
        } else if activity.accessibility <= 0.6 {
            difficultyLabel.text = "🧐 medium"
        } else {
            difficultyLabel.text = "🥵 hard"
        }
        participantLabel.text = String(activity.participants)
    }
}
