//
//  ViewController.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import UIKit

final class ActivityListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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
        
        collectionView.reloadData()
        interactor.fetch() { [weak self] actitivies in
            self?.activities = actitivies
            self?.activityIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
        
    func registerCells() {
        let nib = UINib(nibName: ActivityCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ActivityCell.identifier)
    }
}

extension ActivityListViewController: UICollectionViewDataSource {

    var isCollectionLoading: Bool {
        activities.count == 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.identifier, for: indexPath) as! ActivityCell
        isCollectionLoading ?  cell.starLoading() : cell.configure(activities[indexPath.item])
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCollectionLoading ? 8 : activities.count
    }
}

extension ActivityListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let size =  CGSize(width: collectionView.bounds.width-insets.left-insets.right, height: 160)
        print(size)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: 16,
                            bottom: 0,
                            right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
}
