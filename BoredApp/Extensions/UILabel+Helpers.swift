//
//  UILabel+Helpers.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 12/06/23.
//

import UIKit

extension UILabel {
    
    func strikethroughText(_ title: String, size: CGFloat) {
        let attributedString = NSAttributedString(string: title, attributes:
                                                     [.strikethroughStyle: 2,
                                                      .foregroundColor: UIColor.white,
                                                      .font: UIFont.systemFont(ofSize: size, weight: .semibold)])
        
        attributedText = attributedString
    }
}
