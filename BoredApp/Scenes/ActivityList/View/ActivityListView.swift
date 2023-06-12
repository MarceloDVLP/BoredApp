//
//  ActivityListView.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 12/06/23.
//

import UIKit

final class ActivityListView: UIView {
    
    weak var delegate: ActivityListViewController?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    private var activities: [ActivityModel] = []

    func registerCells() {
        let activityCellNib = UINib(nibName: ActivityCell.identifier, bundle: nil)
        collectionView.register(activityCellNib,
                                forCellWithReuseIdentifier: ActivityCell.identifier)
        
        let filterNib = UINib(nibName: FilterActivityHeaderView.identifier, bundle: nil)
        collectionView.register(filterNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: FilterActivityHeaderView.identifier)
    }
    
    func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        constrainSubView(view: collectionView,
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0)
    }
    
    func showLoading() {
        activities = []
        collectionView.reloadData()
    }
    
    func show(activities: [ActivityModel]) {
        self.activities = activities
        collectionView.reloadData()
    }
    
    func showError() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivityListView: UICollectionViewDataSource {

    var isCollectionLoading: Bool {
        activities.count == 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.identifier, for: indexPath) as! ActivityCell
        cell.delegate = self
        isCollectionLoading ?  cell.starLoading() : cell.configure(activities[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterActivityHeaderView.identifier, for: indexPath) as! FilterActivityHeaderView
        
        header.didTapFilterActivity = { [weak self] in
            self?.delegate?.didTapFilter()
        }
        
        header.didTapMyActivities = { [weak self] isSelected in
            self?.delegate?.didTapMyActivities(isSelected)
        }
        
        return header
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCollectionLoading ? 4 : activities.count
    }
}

extension ActivityListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let size =  CGSize(width: collectionView.bounds.width-insets.left-insets.right, height: 160)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size =  CGSize(width: collectionView.bounds.width, height: 60)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastCell = indexPath.item == activities.count-1
        prepareToPaginate()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16,
                            left: 16,
                            bottom: 0,
                            right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
    
    func prepareToPaginate() {
//        for index in activities.count-1..activities.count+3 {
//            collectionView.insertItems(at: )
//
//        }
    }
}

extension ActivityListView: ActivityCellDelegate {
    
    func userDidTapButton(at cell: ActivityCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let activity = activities[indexPath.item]
        delegate?.userDidTapActivity(activity, indexPath.item, cell: cell)
    }
}
