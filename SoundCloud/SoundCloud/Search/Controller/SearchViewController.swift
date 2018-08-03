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
        static let download = "Download"
        static let retainToLoadmore = 5
        static let numberLoadmore = 20
        static let main = "Main"
        static let playlistViewController = "PlaylistViewController"
    }
    
    private var listTrack = [TrackSearch]()
    private var listHistory = [String]()
    private var listDownloaded = [Track]()
    private var limit = 20
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var suggestionSearchView: SuggestionSearchView!
    @IBOutlet private var resultSearchView: ResultSearchView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSearchbar()
        getData()
        resultSearchView.setContentTableview(viewController: self)
        suggestionSearchView.setContentView(viewController: self)
        suggestionSearchView.delegate = self
    }
    
    func customSearchbar() {
        searchBar.layer.borderColor = Utils.shared.getBaseColor().cgColor
        searchBar.layer.borderWidth = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func getData() {
        listHistory = UserDefaults.standard.stringArray(forKey: Constant.history) ?? [String]()
        listDownloaded = DatabaseManager.shared.getListTrackOfPlaylist(idPlaylist: DatabaseManager.shared.getIDPlaylistByName(name: Constant.download))
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
            for t in listDownloaded {
                if t.id == listTrack[indexPath.row].id {
                    cell.setDownloadedButton()
                    break
                }
            }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listTrack.count - Constant.retainToLoadmore {
            limit += Constant.numberLoadmore
            if let text = searchBar.text {
                handleSearch(text: text, searchBar: searchBar)
            }
        }
    }
}

extension SearchViewController: ResultSearchCellDelegate {
    func clickImageButton(type: ImageButtonType, cell: ResultSearchCell) {
        guard let index = resultSearchView.getTable().indexPath(for: cell) else {
            return
        }
        let track = listTrack[index.row]
        switch type {
        case .download:
            cell.setShowDownloadButton(isShow: false)
            DownloadManager.downloadTrack(track: track, progressDownload: { [weak self] progress in
                guard let `self` = self else {
                    return
                }
                DispatchQueue.main.async {
                    cell.setProgress(value: self.getPercentage(progress: progress))
                }
            }) { (downloadSuccess, error) in
                if downloadSuccess {
                    if !DatabaseManager.shared.checkExistTrack(id: track.id) {
                        if DatabaseManager.shared.addTrack(track: track) {
                            print("Add track to database success")
                        }
                    } else {
                        print("Track is already in database")
                    }
                    if DatabaseManager.shared.addTrackToPlaylist(track: track, idPlaylist: DatabaseManager.shared.getIDPlaylistByName(name: Constant.download)) {
                        print("Add to download")
                    }
                    DispatchQueue.main.async {
                        cell.setShowProgressButton(isShow: false)
                        cell.setDownloadedButton()
                        cell.setShowDownloadButton(isShow: true)
                        DownloadManager.checkIsDownloading(completion: { (isDownloading) in
                            if !isDownloading {
                                self.getData()
                                DispatchQueue.main.async {
                                    self.resultSearchView.reloadTable()
                                }
                            }
                        })
                    }
                }
            }
        case .addToPlaylist:
            let storyboard = UIStoryboard(name: Constant.main, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: Constant.playlistViewController) as? PlaylistViewController {
                vc.trackWantToAdd = track
                self.present(vc, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func getPercentage(progress: Progress) -> CGFloat {
        return CGFloat(progress.completedUnitCount * 100 / progress.totalUnitCount)
    }
}

extension SearchViewController: SuggestionSearchViewDelegate {
    func clickHotButton(title: String?) {
        guard let title = title else {
            return
        }
        searchBar.text = title
        handleSearch(text: title, searchBar: searchBar)
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
            Networking.getSearch(key: text, limit: limit) { [weak self] data, error in
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
