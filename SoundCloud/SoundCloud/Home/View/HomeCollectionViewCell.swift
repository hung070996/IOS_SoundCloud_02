//
//  HomeCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

final class HomeCollectionViewCell: UICollectionViewCell, NibReusable {
    private struct Constant {
        static let placeholder = "Icon_Playlist_Holder"
    }

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContentForCell(track: Track) {
        nameLabel.text = track.title
        let urlString = track.urlImage
        let url = URL(string: urlString)
        let placeholder = UIImage(named: Constant.placeholder)
        image.kf.setImage(with: url, placeholder: placeholder)
    }
}
