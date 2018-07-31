//
//  SearchViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 7/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

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
            cell.setShowDownloadButton(isShow: listTrack[indexPath.row].downloadable)
            cell.setShowProgressButton(isShow: listTrack[indexPath.row].downloadable)
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

extension SearchViewController: ResultSearchCellDelegate {
    func clickImageButton(type: ImageButtonType, cell: ResultSearchCell) {
        cell.setShowDownloadButton(isShow: false)
        if let index = resultSearchView.getTable().indexPath(for: cell) {
            let track = listTrack[index.row]
            DownloadManager.downloadTrack(track: track, progressDownload: { (progress) in
                cell.setProgress(value: self.getPercentage(progress: progress))
            }) { (response) in
                print(response.response?.status)
                print(self.listFilesFromDocumentsFolder())
            }
        }
    }
    
    func listFilesFromDocumentsFolder() -> [String]? {
        let fileManager = FileManager.default;
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        return try? fileManager.contentsOfDirectory(atPath:docs)
    }
    
    func getPercentage(progress: Progress) -> CGFloat {
        return CGFloat(progress.completedUnitCount * 100 / progress.totalUnitCount)
    }
}


extension SearchViewController: SuggestionSearchViewDelegate {
    func clickHotButton(title: String?) {

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
