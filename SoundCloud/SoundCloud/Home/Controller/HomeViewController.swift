//
//  HomeViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    private struct Constant {
        static var homeTableViewCell = "HomeTableViewCell"
        static var homeCollectionViewCell = "HomeCollectionViewCell"
        static var numberOfCellTable = 6
        static var numberOfCellCollection = 10
        static var numberOfCellTableInOneScreen = 3
    }

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constant.homeTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.homeTableViewCell)
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfCellTable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.homeTableViewCell) as? HomeTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: Constant.homeTableViewCell)
        }
        cell.setContentForCell(viewController: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / CGFloat(Constant.numberOfCellTableInOneScreen)
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.numberOfCellCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.homeCollectionViewCell, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setContentForCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.height)
    }
}
