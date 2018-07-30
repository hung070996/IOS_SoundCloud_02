//
//  ResultSearchCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

class ResultSearchCell: UITableViewCell, NibReusable {
    private struct Constant {
        static let placeholder = "Icon_Playlist_Holder"
    }
    
    @IBOutlet private var nameArtistLabel: UILabel!
    @IBOutlet private var nameSongLabel: UILabel!
    @IBOutlet private var imageSong: UIImageView!
    @IBOutlet private var addPlaylistButton: ImageButton!
    @IBOutlet private var downloadButton: ImageButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentForCell(viewController: UIViewController, track: TrackSearch) {
        addPlaylistButton.muttating(type: ImageButtonType.addToPlaylist)
        addPlaylistButton.setTintColorOfImage(color: .black)
        addPlaylistButton.delegate = viewController as? ImageButtonDelegate
        downloadButton.muttating(type: ImageButtonType.download)
        downloadButton.setTintColorOfImage(color: .black)
        downloadButton.delegate = viewController as? ImageButtonDelegate
        nameSongLabel.text = track.title
        nameArtistLabel.text = track.genre
        let urlString = track.urlImage
        let url = URL(string: urlString)
        let placeholder = UIImage(named: Constant.placeholder)
        imageSong.kf.setImage(with: url, placeholder: placeholder)
    }
    
    func setShowDownloadButton(isShow: Bool) {
        downloadButton.isHidden = !isShow
    }
}
