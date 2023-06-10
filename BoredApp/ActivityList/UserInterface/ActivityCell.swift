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
    var isLoading: Bool = false
    var color: UIColor?

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
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        layer.shadowOffset = CGSize(width: 1, height: 5)
        // Improve scrolling performance with an explicit shadowPath
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
//
    }
    
    func starLoad() {
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
            })

            activityType.textColor = color
            self.color = color
        }
    }
}

enum ActivityType: String {
    case education
    case recreational
    case social
    case diy
    case charity
    case cooking
    case relaxation
    case music
    case busywork
    case none
    
    var color: String {
        switch self {
        case .education:
            return "#EB9E9A"
        case .recreational:
            return "#E0C6AF"
        case .social:
            return "#B0DAC1"
        case .diy:
            return "#E59CBA"
        case .charity:
            return "#C4C7A4"
        case .cooking:
            return "#165AA1"
        case .relaxation:
            return "#71A9E3"
        case .music:
            return "#7C2D4A"
        case .busywork:
            return "#29AEC0"
        case .none:
            return "#CCBE9A"
        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return nil
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIView {
    
    func setRadiusAndShadow(_ color: UIColor) {
        clipsToBounds = true
        let shadowLayer = CAShapeLayer()
        
        layer.cornerRadius = 12
        shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: layer.cornerRadius).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.4
        shadowLayer.shadowRadius = 12
        layer.insertSublayer(shadowLayer, at: 0)
        layer.masksToBounds = false
    }
    
    enum Direction: Int {
       case topToBottom = 0
       case bottomToTop
       case leftToRight
       case rightToLeft
     }
     
    func startShimmeringAnimation() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "shimmerlayer"
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        let gradientColorOne = UIColor(white: 0.90, alpha: 1.0).cgColor
        let gradientColorTwo = UIColor(white: 0.95, alpha: 1.0).cgColor
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        self.layer.addSublayer(gradientLayer)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1
        gradientLayer.add(animation, forKey: animation.keyPath)
     }
    
     func stopShimmeringAnimation() {
         self.layer.mask = nil
         self.layer.removeAllAnimations()
         if let layer = self.layer.sublayers?.first(where: { $0.name == "shimmerlayer" }) {
             layer.removeAllAnimations()
             layer.removeFromSuperlayer()
         }
     }
}
