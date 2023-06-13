//
//  ActivityListView.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 12/06/23.
//

import UIKit

protocol ActivityListViewDelegate: AnyObject {
    func didTapFilter()
    func didTapMyActivities(_ isSelected: Bool)
    func didTapTryAgain()
    func userDidTapActivity(_ activity: ActivityItem, _ index: Int, cell: ActivityCell)
}

final class ActivityListView: UIView {
    
    weak var delegate: ActivityListViewDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    private var activities: [ActivityItem]?
    private var showErrorState: Bool = false

    func registerCells() {
        let activityCellNib = UINib(nibName: ActivityCell.identifier, bundle: nil)
        collectionView.register(activityCellNib,
                                forCellWithReuseIdentifier: ActivityCell.identifier)
        
        let filterNib = UINib(nibName: FilterActivityHeaderView.identifier, bundle: nil)
        collectionView.register(filterNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: FilterActivityHeaderView.identifier)

        let emptyState = UINib(nibName: EmptyStateCell.identifier, bundle: nil)
        collectionView.register(emptyState,
                                forCellWithReuseIdentifier: EmptyStateCell.identifier)

        let errorNib = UINib(nibName: ErrorCell.identifier, bundle: nil)
        collectionView.register(errorNib,
                                forCellWithReuseIdentifier: ErrorCell.identifier)

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
        backgroundColor = Colors.backGroundColor
    }
    
    func showLoading() {
        activities = nil
        showErrorState = false
        collectionView.reloadData()
    }
    
    func show(activities: [ActivityItem]) {
        self.activities = activities
        collectionView.reloadData()
    }
    
    func showError() {
        showErrorState = true
        collectionView.reloadData()
    }
    
    func show(_ activity: ActivityItem, at index: Int) {
        guard var activities = self.activities else { return }
        activities[index] = activity
        self.activities = activities
    
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ActivityCell {
            cell.update(activity: activity)
        }
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
        activities == nil
    }
    
    var showEmptyState: Bool {
        if let activities, activities.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if showErrorState,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCell.identifier,                                                      for: indexPath) as? ErrorCell {

            cell.didTapTryAgain = { [weak self] in
                self?.showLoading()
                self?.delegate?.didTapTryAgain()
            }
            return cell
        }
        
        if showEmptyState {
            return collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCell.identifier,                                                      for: indexPath)
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.identifier, for: indexPath) as? ActivityCell {
            cell.delegate = self
            isCollectionLoading ?  cell.starLoading() : cell.configure(activities?[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
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
        if showEmptyState || showErrorState { return 1 }
        if isCollectionLoading { return 4 }
        return activities?.count ?? 0
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16,
                            left: 16,
                            bottom: 0,
                            right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
}

extension ActivityListView: ActivityCellDelegate {
    
    func userDidTapButton(at cell: ActivityCell) {
        guard let indexPath = collectionView.indexPath(for: cell), let activities else { return }
        let activity = activities[indexPath.item]
        delegate?.userDidTapActivity(activity, indexPath.item, cell: cell)
    }
}
