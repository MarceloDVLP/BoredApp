//
//  UIView+Helpers.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 10/06/23.
//

import UIKit

extension UIView {
    
    func setRadiusAndShadow(cornerRadius: CGFloat = 12) {
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
    
    func constrainSubView(view: UIView,
                          top: CGFloat? = nil,
                          bottom: CGFloat? = nil,
                          left: CGFloat? = nil,
                          right: CGFloat? = nil,
                          width: CGFloat? = nil,
                          height: CGFloat? = nil,
                          x: CGFloat? = nil,
                          y: CGFloat? = nil
    ) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        var constraints: [NSLayoutConstraint] = []
        
        if let top = top {
            constraints.append(view.topAnchor.constraint(equalTo: topAnchor, constant: top))
        }

        if let left = left {
            constraints.append(view.leftAnchor.constraint(equalTo: leftAnchor, constant: left))
        }

        if let right = right {
            constraints.append(view.rightAnchor.constraint(equalTo: rightAnchor, constant: right))
        }

        if let bottom = bottom {
            constraints.append(view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom))
        }

        if let width = width {
            constraints.append(view.widthAnchor.constraint(equalToConstant: width))
        }

        if let height = height {
            constraints.append(view.heightAnchor.constraint(equalToConstant: height))
        }
        
        if let x = x {
            constraints.append(view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: x))
        }

        if let y = y {
            constraints.append(view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: y))
        }

        NSLayoutConstraint.activate(constraints)
    }
}

extension UIButton {
    
    func transparentStyle(title: String, with radius: CGFloat = 20) {
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = radius
        layer.borderWidth = 2

        let attributedString = NSAttributedString(string: title, attributes:
                                                    [.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                     .foregroundColor: UIColor.white,
                                                     .font: UIFont.titleFont()])

        let highlightedString = NSAttributedString(string: title, attributes:
                                                    [.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                    .foregroundColor: UIColor.lightGray,
                                                    .font: UIFont.titleFont()])

        setAttributedTitle(attributedString, for: .normal)
        setAttributedTitle(highlightedString, for: .highlighted)
    }
}

extension UIFont {
    
    static func titleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .heavy)
    }
}

