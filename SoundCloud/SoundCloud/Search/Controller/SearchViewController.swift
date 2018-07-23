//
//  SearchViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 7/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    private struct Constant {
        static let numberOfCellTable = 10
    }
    
    @IBOutlet private var suggestionSearchView: SuggestionSearchView!
    @IBOutlet private var resultSearchView: ResultSearchView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionSearchView.setContentTableView(viewController: self)
        suggestionSearchView.delegate = self
        resultSearchView.setContentTableview(viewController: self)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfCellTable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == suggestionSearchView.getTable() {
            let cell: HistorySearchCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setContentForCell(viewController: self)
            return cell
        } else {
            let cell: ResultSearchCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setContentForCell(viewController: self)
            return cell
        }
    }
}

extension SearchViewController: ResultSearchCellDelegate {
    func clickAddToPlaylist() {
        print("clickAddToPlaylist")
    }
    
    func clickDownload() {
        print("clickDownload")
    }
}

extension SearchViewController: SuggestionSearchViewDelegate {
    func clickHotButton(title: String?) {
        print(title)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        suggestionSearchView.isHidden = searchText.isEmpty ? false : true
    }
}
