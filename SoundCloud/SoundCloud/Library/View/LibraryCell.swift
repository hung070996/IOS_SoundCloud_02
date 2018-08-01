//
//  LibraryCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class LibraryCell: UITableViewCell, NibReusable {
    @IBOutlet private var number: UILabel!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentForCell(img: String, title: String, number: Int) {
        let image = UIImage(named: img)
        self.img.image = image
        self.title.text = title
        self.number.text = String(number)
    }
}
