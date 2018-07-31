//
//  CurrentPlaylistTableViewCell.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class CurrentPlaylistTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var lblIndex: UILabel!
    @IBOutlet private weak var lblNameOfSong: UILabel!
    @IBOutlet private weak var lblSinger: UILabel!
    
    func fillData(index: Int, track: Track) {
        lblIndex.text = String(index)
        lblNameOfSong.text = track.title
        lblSinger.text = track.artist
    }
}
