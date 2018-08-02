//
//  PlaylistCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

protocol PlaylistCellDelegate: class {
    func clickImageButton(type: ImageButtonType, cell: PlaylistCell)
}

class PlaylistCell: UITableViewCell, NibReusable {
    private struct Constant {
        static let cornerRadius = 10
        static let song = " song"
        static let songs = " songs"
    }
    
    weak var delegate: PlaylistCellDelegate?
    
    @IBOutlet private var editButton: ImageButton!
    @IBOutlet private var deleteButton: ImageButton!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var imagePlaylist: ImageButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentForCell(viewController: UIViewController, playlist: Playlist) {
        self.delegate = viewController as? PlaylistCellDelegate
        editButton.muttating(type: ImageButtonType.edit)
        editButton.setTintColorOfImage(color: .black)
        editButton.delegate = self
        deleteButton.muttating(type: ImageButtonType.delete)
        deleteButton.setTintColorOfImage(color: .black)
        deleteButton.delegate = self
        imagePlaylist.muttating(type: ImageButtonType.playlist)
        imagePlaylist.setTintColorOfImage(color: .white)
        imagePlaylist.layer.cornerRadius = CGFloat(Constant.cornerRadius)
        self.nameLabel.text = playlist.name
        self.numberLabel.text = playlist.listTrack.count < 2 ? String(playlist.listTrack.count) + Constant.song
            : String(playlist.listTrack.count) + Constant.songs
    }
}

extension PlaylistCell: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        delegate?.clickImageButton(type: type, cell: self)
    }
}
