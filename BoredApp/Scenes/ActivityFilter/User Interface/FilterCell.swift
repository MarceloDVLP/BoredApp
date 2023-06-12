import UIKit

final class FilterCell: UICollectionViewCell {
    
    private lazy var seasonLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constrainSubView(view: seasonLabel, top: 0, left: 0, right: 0)
    }
    
    public func configure(season: String, isSelected: Bool) {
        seasonLabel.text = season
        select(isSelected)
    }
    
    override var isSelected: Bool {
        didSet {
            select(isSelected)
        }
    }
    
    func select(_ isSelected: Bool) {
        self.seasonLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.seasonLabel.textColor = Colors.mediumTitleColor        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
