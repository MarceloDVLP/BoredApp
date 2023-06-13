//
//  ErrorCell.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 12/06/23.
//

import UIKit

final class ErrorCell: UICollectionViewCell {

    var didTapTryAgain: (() -> ())?
    
    static let identifier: String = String(describing: ErrorCell.self)
    
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.transparentStyle(title: "Try Again", with: 12)
        button.layer.borderWidth = 0
    }
    
    @IBAction func didTapButton(_ sender: UIButton)  {
        didTapTryAgain?()
    }
}
