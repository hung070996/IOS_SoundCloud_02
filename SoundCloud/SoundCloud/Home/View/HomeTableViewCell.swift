//
//  HomeTableViewCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class HomeTableViewCell: UITableViewCell, NibReusable {
    private struct Identifier {
        static let homeCollectionViewCell = "HomeCollectionViewCell"
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var seeAllButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setContentForCell(viewController: UIViewController) {
        self.collectionView.delegate = viewController as? UICollectionViewDelegate
        self.collectionView.dataSource = viewController as? UICollectionViewDataSource
        self.collectionView.register(cellType: HomeCollectionViewCell.self)
    }
}
