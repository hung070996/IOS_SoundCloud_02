//
//  ListSongViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class ListSongViewController: UIViewController {
    private struct Constant {
        static let title = "List Song"
        static let estimatedRowHeight = 100
        static let success = "Success"
        static let failure = "Failure"
        static let yes = "Yes"
        static let no = "No"
        static let confirm = "Confirm"
        static let confirmDelete = "Do you want to remove this track from playlist?"
        static let refresh = "refresh"
    }
    
    var playlist = Playlist()
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var titleView: TitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        getData()
        setTableView()
        setTitleView()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name.init(Constant.refresh), object: nil)
    }
    
    @objc func getData() {
        for playlist in DatabaseManager.shared.getListPlaylist() {
            if playlist.name == self.playlist.name {
                self.playlist = playlist
            }
        }
        tableView.reloadData()
    }
    
    func setTableView() {
        tableView.register(cellType: ResultSearchCell.self)
        tableView.estimatedRowHeight = CGFloat(Constant.estimatedRowHeight)
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setTitleView() {
        titleView.setTitle(title: playlist.name)
        titleView.setButton(type: .back)
        titleView.setDelegateForButton(viewController: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ListSongViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.listTrack.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultSearchCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(viewController: self, track: playlist.listTrack[indexPath.row])
        cell.changeToListSongCell()
        return cell
    }
}

extension ListSongViewController: ResultSearchCellDelegate {
    func clickImageButton(type: ImageButtonType, cell: ResultSearchCell) {
        guard let index = tableView.indexPath(for: cell) else {
            return
        }
        let track = playlist.listTrack[index.row]
        if type == .delete {
            let actionYes = UIAlertAction(title: Constant.yes, style: .default) { (action) in
                if DatabaseManager.shared.deleteTrackFromPlaylist(idTrack: track.getID(), idPlaylist: self.playlist.getID()) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(Constant.refresh), object: nil)
                    self.view.makeToast(Constant.success)
                } else {
                    self.view.makeToast(Constant.failure)
                }
            }
            let actionNo = UIAlertAction(title: Constant.no, style: .cancel, handler: nil)
            showConfirmAlert(title: Constant.confirm, message: Constant.confirmDelete, actions: [actionYes, actionNo])
        }
    }
}

extension ListSongViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        if type == .back {
            navigationController?.popViewController(animated: true)
        }
    }
}
