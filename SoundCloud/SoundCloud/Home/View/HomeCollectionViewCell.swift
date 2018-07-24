//
//  HomeCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class HomeCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContentForCell() {
        
    }
}
