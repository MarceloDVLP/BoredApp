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
}
