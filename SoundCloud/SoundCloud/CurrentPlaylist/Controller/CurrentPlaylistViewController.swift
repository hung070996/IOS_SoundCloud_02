//
//  CurrentPlaylistViewController.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

protocol CurrentPlaylistDelegate: class {
    func cellDidTap(track: Track)
}

class CurrentPlaylistViewController: UIViewController {
    @IBOutlet private weak var tblListCurrentSong: UITableView!
    var dataArray = [Track]()
    weak var delegate: CurrentPlaylistDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableDisplay()
        registerCell()
    }
    
    func reloadPlaylist() {
        tblListCurrentSong?.reloadData()
    }
    
    private func setTableDisplay() {
        tblListCurrentSong.estimatedRowHeight = 70
        tblListCurrentSong.rowHeight = UITableViewAutomaticDimension
        tblListCurrentSong.separatorStyle = .none
    }
    
    private func registerCell() {
        tblListCurrentSong.register(cellType: CurrentPlaylistTableViewCell.self)
    }
}

extension CurrentPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CurrentPlaylistTableViewCell
        cell.selectionStyle = .none
        cell.fillData(index: indexPath.row + 1, track: dataArray[indexPath.row])
        let collor: UIColor = PlaySongManager.shared.getCurrentTrackIndex() == indexPath.row ? .orange : .purple
        cell.backgroundColor = collor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.cellDidTap(track: dataArray[indexPath.row])
    }
}
