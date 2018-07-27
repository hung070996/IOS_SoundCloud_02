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
        static let history = "history"
    }
    
    private var listTrack = [TrackSearch]()
    private var listHistory = [String]()
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var suggestionSearchView: SuggestionSearchView!
    @IBOutlet private var resultSearchView: ResultSearchView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataHistory()
        resultSearchView.setContentTableview(viewController: self)
        suggestionSearchView.setContentView(viewController: self)
        suggestionSearchView.delegate = self
    }
    
    func getDataHistory() {
        listHistory = UserDefaults.standard.stringArray(forKey: Constant.history) ?? [String]()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == suggestionSearchView.getTable() ? listHistory.count : listTrack.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == suggestionSearchView.getTable() {
            let cell: HistorySearchCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setContentForCell(viewController: self, label: listHistory[listHistory.count - indexPath.row - 1])
            return cell
        } else {
            let cell: ResultSearchCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setContentForCell(viewController: self, track: listTrack[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == suggestionSearchView.getTable() {
            searchBar.text = listHistory[listHistory.count - indexPath.row - 1]
            handleSearch(text: listHistory[listHistory.count - indexPath.row - 1], searchBar: searchBar)
        } else {
            if let text = searchBar.text {
                listHistory.append(text)
                suggestionSearchView.reloadTable()
                UserDefaults.standard.set(listHistory, forKey: Constant.history)
            }
        }
    }
}

extension SearchViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        print(type)
    }
}

extension SearchViewController: SuggestionSearchViewDelegate {
    func clickHotButton(title: String?) {
        print(title)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearch(text: searchText, searchBar: searchBar)
    }
    
    func handleSearch(text: String, searchBar: UISearchBar) {
        if text.isEmpty {
            suggestionSearchView.isHidden = false
        } else {
            suggestionSearchView.isHidden = true
            APIManager.shared.cancelRequest()
            searchBar.isLoading = true
            Networking.getSearch(key: text) { [weak self] data, error in
                if let error = error {
                    if let message = error.errorMessage {
                        DispatchQueue.main.async {
                            self?.showErrorAlert(message: message)
                        }
                    }
                } else {
                    if let data = data {
                        DispatchQueue.main.async {
                            searchBar.isLoading = false
                            self?.listTrack = data.collection
                            self?.resultSearchView.reloadTable()
                            self?.resultSearchView.setNumberResult(number: data.total)
                        }
                    }
                }
            }
        }
    }
}
