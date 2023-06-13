//
//  UIButton+Helpers.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 12/06/23.
//

import UIKit

extension UIButton {
    
    func transparentStyle(title: String, with radius: CGFloat = 20) {
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = radius
        layer.borderWidth = 0

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
    
    func finishedStyle(title: String) {
        backgroundColor = .clear
        layer.borderWidth = 0

        let attributedString = NSAttributedString(string: title, attributes:
                                                    [.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                    .foregroundColor: UIColor.white,
                                                     .font: UIFont.systemFont(ofSize: 12, weight: .semibold)])

        setAttributedTitle(attributedString, for: .normal)
        setAttributedTitle(attributedString, for: .highlighted)
    }
    
    func strokeText(_ title: String) {
        let attributedString = NSAttributedString(string: title, attributes:
                                                    [.strokeWidth: 2,
                                                     .strokeColor: UIColor.darkGray,
                                                    .foregroundColor: UIColor.white,
                                                     .font: UIFont.systemFont(ofSize: 12, weight: .semibold)])
        
        setAttributedTitle(attributedString, for: .normal)
        setAttributedTitle(attributedString, for: .highlighted)
    }
}
