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
        static let numberOfCellTable = 6
        static let numberOfCellCollection = 10
        static let numberOfCellTableInOneScreen = 3
        static let numberOfCellCollectionInOneScreen = 3
        static let title = "Home"
    }

    @IBOutlet private var titleView: TitleView!
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView() {
        tableView.register(cellType: HomeTableViewCell.self)
    }
    
    func setTitleView() {
        titleView.setTitle(title: Constant.title)
        titleView.setShowLeftButton(isShow: false)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfCellTable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(viewController: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / CGFloat(Constant.numberOfCellTableInOneScreen)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.numberOfCellCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / CGFloat(Constant.numberOfCellCollectionInOneScreen), height: collectionView.frame.size.height)
    }
}
