//
//  FilterActivityHeaderView.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 10/06/23.
//

import UIKit

class FilterActivityHeaderView: UICollectionReusableView {
    @IBOutlet weak var filterIconImageView: UIImageView!
    @IBOutlet weak var typeFilterLabel: UILabel!
    var didTap: (() ->())?
    @IBOutlet weak var typeContainerView: UIView!
    static let identifier: String = String(describing: FilterActivityHeaderView.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        typeFilterLabel.textColor = Colors.titleColor
        filterIconImageView.image = UIImage(named: "arrow-down")?.withTintColor(Colors.titleColor, renderingMode: .alwaysOriginal)
        typeContainerView.layer.borderWidth = 1
        typeContainerView.layer.borderColor = Colors.titleColor.cgColor
        typeContainerView.layer.cornerRadius = 8
        
        typeContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFilter)))
    }
    
    @objc func didTapFilter() {
        didTap?()
    }
}
