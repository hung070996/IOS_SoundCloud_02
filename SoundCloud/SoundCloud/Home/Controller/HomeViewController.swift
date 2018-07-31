//
//  HomeViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import SpringIndicator

final class HomeViewController: UIViewController {
    private struct Constant {
        static let title = "Home"
        static let numberOfCellCollectionInOneScreen = 3
        static let estimateRowHeight = 100
    }
    
    private var listGenre = [Genre]()
    private var order = [GenreType]()

    @IBOutlet private var titleView: TitleView!
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setTitleView()
        loadData()
    }
    
    func loadData() {
        let loading = indicator
        loading.start()
        order = [.allMusic, .allAudio, .alternativeRock, .ambient, .classical, .country]
        Networking.getGenres(listGenre: order) { [weak self] data, error in
            if let error = error {
                if let message = error.errorMessage {
                    DispatchQueue.main.async {
                        self?.showErrorAlert(message: message)
                    }
                }
            } else {
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    self?.listGenre = data
                    self?.listGenre.sort(by: { $0.genreType.rawValue < $1.genreType.rawValue })
                    self?.tableView.reloadData()
                    loading.stop()
                }
            }
        }
    }
    
    func setTableView() {
        tableView.register(cellType: HomeTableViewCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CGFloat(Constant.estimateRowHeight)
    }
    
    func setTitleView() {
        titleView.setTitle(title: Constant.title)
        titleView.setShowLeftButton(isShow: false)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGenre.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(viewController: self, genre: listGenre[indexPath.row], tag: indexPath.row)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listGenre[collectionView.tag].collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let genre = listGenre[collectionView.tag]
        cell.setContentForCell(track: genre.collection[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / CGFloat(Constant.numberOfCellCollectionInOneScreen), height: collectionView.frame.size.height)
    }
}
