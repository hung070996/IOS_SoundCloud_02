//
//  HomeTableViewCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    private struct Identifier {
        static var homeCollectionViewCell = "HomeCollectionViewCell"
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var seeAllButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContentForCell(viewController : UIViewController) {
        self.collectionView.delegate = viewController as? UICollectionViewDelegate
        self.collectionView.dataSource = viewController as? UICollectionViewDataSource
        self.collectionView.register(UINib(nibName: Identifier.homeCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifier.homeCollectionViewCell)
    }
}
