//
//  HistorySearchCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class HistorySearchCell: UITableViewCell, NibReusable {
    @IBOutlet private var labelHistory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentForCell(viewController: UIViewController, label: String) {
        labelHistory.text = label
    }
}
