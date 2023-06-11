//
//  ViewController.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import UIKit

final class ActivityListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    private lazy var interactor: ActivityListInteractor = {
        return ActivityListInteractor()
    }()
    
    var activities: [ActivityModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        title = "Never Bored!"
        
        view.backgroundColor = Colors.backGroundColor
        collectionView.backgroundColor = .clear
        
        fetch(userActivities: false, filters: [])
    }
        
    func registerCells() {
        let activityCellNib = UINib(nibName: ActivityCell.identifier, bundle: nil)
        collectionView.register(activityCellNib,
                                forCellWithReuseIdentifier: ActivityCell.identifier)
        
        let filterNib = UINib(nibName: FilterActivityHeaderView.identifier, bundle: nil)
        collectionView.register(filterNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: FilterActivityHeaderView.identifier)
    }
}

extension ActivityListViewController: UICollectionViewDataSource {

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
            self?.didTapFilter()
        }
        
        header.didTapMyActivities = { [weak self] isSelected in
            self?.didTapMyActivities(isSelected)
        }        
        
        return header
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCollectionLoading ? 4 : activities.count
    }
}

extension ActivityListViewController {

    private func didTapFilter() {
        let viewController = FilterViewController(items: ActivityType.allCases.map({ $0.rawValue }), selectedIndex: -1)

        viewController.didSelectItem = { [weak self] selected in
            self?.fetch(userActivities: true, filters: selected)
        }
        present(viewController, animated: true)
    }
    
    private func didTapMyActivities(_ isSelected: Bool) {
        fetch(userActivities: isSelected, filters: [])
    }
    
    func fetch(userActivities: Bool, filters: [String]) {
        activities = []
        collectionView.reloadData()
        interactor.fetch(filters: filters, userActivities: userActivities) { [weak self] activities in
            self?.activities = activities
            self?.collectionView.reloadData()
        }
    }
}

extension ActivityListViewController: UICollectionViewDelegateFlowLayout {
    
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

extension ActivityListViewController: ActivityCellDelegate {

    func userDidTapButton(at cell: ActivityCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        if interactor.isActivityStarted(at: indexPath.item) {
            showAlert(for: indexPath, cell: cell)
        } else {
            interactor.start(at: indexPath.item)
        }
    }
    
    func showAlert(for indexPath: IndexPath, cell: ActivityCell) {
        
        let alert = UIAlertController(title: nil, message: "Did you finish?", preferredStyle: .actionSheet)

        let actionFinished = UIAlertAction(title: "Yes! I finished", style: .default) { _ in
            self.setActivityState(state: .finished,
                             at: indexPath.item,
                             cell)
        }
        
        let actionAbort = UIAlertAction(title: "No! I'm bored", style: .destructive) { _ in
            self.setActivityState(state: .aborted,
                             at: indexPath.item,
                             cell)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(actionFinished)
        alert.addAction(actionAbort)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func setActivityState(state: ActivityState, at index: Int, _ cell: ActivityCell) {
        interactor.setState(state: state, for: index)
        cell.update(activity: interactor.activity(for: index))
    }
}

