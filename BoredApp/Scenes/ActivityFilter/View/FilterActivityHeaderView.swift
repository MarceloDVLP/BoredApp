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
        } else {
            selectMyActivityFilter(gesture.view)
        }
    }
    
    func selectMyActivityFilter(_ view: UIView?) {
        let isSelected = !(view?.backgroundColor == .white)
        
        view?.backgroundColor = isSelected ? .white : .clear
        
        (view?.subviews.first as? UILabel)?.textColor = isSelected ? UIColor.black : Colors.titleColor
        
        icons.last?.image = UIImage(named: "arrow-down")?.withTintColor(isSelected ? UIColor.black : Colors.titleColor,
                                                                        renderingMode: .alwaysOriginal)
        
        didTapMyActivities?(isSelected)
    }
}
