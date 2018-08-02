//
//  ListSongWithGenreViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 8/2/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class ListSongWithGenreViewController: UIViewController {
    private struct Constant {
        static let retainToLoadmore = 5
        static let numberLoadmore = 20
        static let download = "Download"
        static let main = "Main"
        static let playlistViewController = "PlaylistViewController"
    }
    
    @IBOutlet private var titleView: TitleView!
    @IBOutlet private var tableView: UITableView!
    
    var genre = Genre()
    var listDownloaded = [Track]()
    var limit = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListDownload()
        setTableView()
        setTitleView()
    }
    
    func setTableView() {
        tableView.register(cellType: ResultSearchCell.self)
    }
    
    func setTitleView() {
        titleView.setTitle(title: genre.genreType.getNameType)
        titleView.setButton(type: .back)
        titleView.setDelegateForButton(viewController: self)
    }
    
    func getListDownload() {
        listDownloaded = DatabaseManager.shared.getListTrackOfPlaylist(idPlaylist: DatabaseManager.shared.getIDPlaylistByName(name: Constant.download))
    }
    
    func getData() {
        Networking.getGenreByType(type: genre.genreType, limit: limit) { [weak self] genre, error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                if let message = error.errorMessage {
                    DispatchQueue.main.async {
                        self.showErrorAlert(message: message)
                    }
                }
            } else {
                if let genre = genre {
                    DispatchQueue.main.async {
                        self.genre = genre
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ListSongWithGenreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genre.collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultSearchCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(viewController: self, track: genre.collection[indexPath.row])
        cell.setShowDownloadButton(isShow: genre.collection[indexPath.row].downloadable)
        cell.setShowProgressButton(isShow: genre.collection[indexPath.row].downloadable)
        for t in listDownloaded {
            if t.id == genre.collection[indexPath.row].id {
                cell.setDownloadedButton()
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == genre.collection.count - Constant.retainToLoadmore {
            limit += Constant.numberLoadmore
            getData()
        }
    }
}

extension ListSongWithGenreViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        if type == .back {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension ListSongWithGenreViewController: ResultSearchCellDelegate {
    func clickImageButton(type: ImageButtonType, cell: ResultSearchCell) {
        guard let index = tableView.indexPath(for: cell) else {
            return
        }
        let track = genre.collection[index.row]
        switch type {
        case .download:
            cell.setShowDownloadButton(isShow: false)
            DownloadManager.downloadTrack(track: track, progressDownload: { [weak self] progress in
                guard let `self` = self else {
                    return
                }
                cell.setProgress(value: self.getPercentage(progress: progress))
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
                                self.getListDownload()
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
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
