//
//  ResultSearchCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

protocol ResultSearchCellDelegate: class {
    func clickAddToPlaylist()
    func clickDownload()
}

class ResultSearchCell: UITableViewCell, NibReusable {
    weak var delegate: ResultSearchCellDelegate?
    @IBOutlet private var nameArtistLabel: UILabel!
    @IBOutlet private var nameSongLabel: UILabel!
    @IBOutlet private var imageSong: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentForCell(viewController: UIViewController) {
        self.delegate = viewController as? ResultSearchCellDelegate
    }
    
    @IBAction func clickAddToPlaylist(_ sender: Any) {
        delegate?.clickAddToPlaylist()
    }
    
    @IBAction func clickDownload(_ sender: Any) {
        delegate?.clickDownload()
    }
}
