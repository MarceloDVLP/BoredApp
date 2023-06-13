//
//  FilterActivityHeaderView.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 10/06/23.
//

import UIKit

final class FilterActivityHeaderView: UICollectionReusableView {
    
    @IBOutlet private var icons: [UIImageView]!
    @IBOutlet private var labels: [UILabel]!
    @IBOutlet private var views: [UIView]!

    @IBOutlet private var myActivityLabel: UILabel!
    @IBOutlet private var myActivityContainer: UIView!

    
    var didTapFilterActivity: (() ->())?
    var didTapMyActivities: ((Bool) ->())?

    static let identifier: String = String(describing: FilterActivityHeaderView.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        
        labels.forEach({ label in
            label.textColor = Colors.titleColor
        })

        icons.forEach({ icon in
            icon.image = UIImage(named: "arrow-down")?.withTintColor(Colors.titleColor, renderingMode: .alwaysOriginal)
        })
        
        views.forEach({ view in
            view.layer.borderWidth = 1
            view.layer.borderColor = Colors.titleColor.cgColor
            view.layer.cornerRadius = 8            
            view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(didTapFilter)))
        })
    }
    
    @objc func didTapFilter(_ gesture: UITapGestureRecognizer) {
        if gesture.view?.tag == 0 {
            didTapFilterActivity?()
            selectMyActivityFilter(false)
        } else {
            let isSelected = !(myActivityContainer.backgroundColor == .white)
            selectMyActivityFilter(isSelected)
            didTapMyActivities?(isSelected)
        }
    }
    
    func selectMyActivityFilter(_ isSelected: Bool) {
        
        myActivityContainer.backgroundColor = isSelected ? .white : .clear
        myActivityLabel.textColor = isSelected ? UIColor.black : Colors.titleColor
        
        icons.last?.image = UIImage(named: "arrow-down")?.withTintColor(isSelected ? UIColor.black : Colors.titleColor,
                                                                        renderingMode: .alwaysOriginal)
        
    }
}
