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
    
    var activities: [ActivityCodable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        title = "Never Bored!"
        
        view.backgroundColor = Colors.backGroundColor
        collectionView.backgroundColor = .clear
        collectionView.reloadData()
        interactor.fetch() { [weak self] actitivies in
            self?.activities = actitivies
            self?.collectionView.reloadData()
        }
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
        header.didTap = { [weak self] in
            let viewController = FilterViewController(items: ActivityType.allCases.map({ $0.rawValue }), selectedIndex: -1)
            viewController.didSelectItem = { [weak self] selected in
                self?.activities = []
                self?.collectionView.reloadData()
                self?.interactor.fetch(filters: selected) { [weak self] activities in
                    self?.activities = activities
                    self?.collectionView.reloadData()
                }
            }
            self?.present(viewController, animated: true)
        }
        return header
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCollectionLoading ? 4 : activities.count
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
    
    func showAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}

enum Colors {
    static let mediumTitleColor = UIColor.white
    static let backGroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.00)
    static let titleColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
    static let titleInactiveColor = UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 1.00)
    static let lineColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00)
    static let activeLineColor = UIColor(red: 0.66, green: 0.66, blue: 0.66, alpha: 1.00)
}
