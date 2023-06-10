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
    @IBOutlet weak var difficultyContainerView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var typeContainerView: UIView!
    @IBOutlet weak var priceContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var participantImageView: UIImageView!
    @IBOutlet weak var participantContainerView: UIView!
    @IBOutlet weak var activityType: UILabel!
    var color: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        

        
        let image = UIImage(named: "start")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        actionButton.setImage(image, for: .normal)
        actionButton.setImage(nil, for: .highlighted)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.cornerRadius = cornerRadius
//        layer.masksToBounds = false
//        layer.shadowRadius = 8.0
//        layer.shadowOpacity = 0.5
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 1, height: 5)
//        // Improve scrolling performance with an explicit shadowPath
//        layer.shadowPath = UIBezierPath(
//            roundedRect: bounds,
//            cornerRadius: cornerRadius
//        ).cgPath
//        
    }
    
    func starLoad() {
        let views: [UIView] = [
            nameLabel,
            priceContainerView,
            participantContainerView,
            typeContainerView,
            difficultyContainerView
        ]
        
        views.forEach({ label in
            label.backgroundColor = .lightGray
            
            label.startShimmeringAnimation()
        })
//
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.startShimmeringAnimation()
    }
    
    func configure(_ activity: ActivityCodable) {
        
        nameLabel.stopShimmeringAnimation()
        priceLabel.stopShimmeringAnimation()
        difficultyLabel.stopShimmeringAnimation()
        participantLabel.stopShimmeringAnimation()
        activityType.stopShimmeringAnimation()
        
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
        
        if let type = ActivityType(rawValue: activity.type), let color = UIColor(hex: type.color) {
            containerView.backgroundColor = color
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
     
     func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                   direction: Direction = .leftToRight,
                                   repeatCount: Float = MAXFLOAT) {
       
       // Create color  ->2
       let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
       let blackColor = UIColor.black.cgColor
       
       // Create a CAGradientLayer  ->3
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [blackColor, lightColor, blackColor]
       gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
       
       switch direction {
       case .topToBottom:
         gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
         gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
         
       case .bottomToTop:
         gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
         gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
         
       case .leftToRight:
         gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
         gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
         
       case .rightToLeft:
         gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
         gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
       }
       
       gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
       self.layer.mask = gradientLayer
       
       // Add animation over gradient Layer  ->4
       CATransaction.begin()
       let animation = CABasicAnimation(keyPath: "locations")
       animation.fromValue = [0.0, 0.1, 0.2]
       animation.toValue = [0.8, 0.9, 1.0]
       animation.duration = CFTimeInterval(animationSpeed)
       animation.repeatCount = repeatCount
       CATransaction.setCompletionBlock { [weak self] in
         guard let strongSelf = self else { return }
         strongSelf.layer.mask = nil
       }
       gradientLayer.add(animation, forKey: "shimmerAnimation")
       CATransaction.commit()
     }
     
     func stopShimmeringAnimation() {
       self.layer.mask = nil
     }
}
