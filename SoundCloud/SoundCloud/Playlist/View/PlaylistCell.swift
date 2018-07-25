//
//  PlaylistCell.swift
//  SoundCloud
//
//  Created by Do Hung on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class PlaylistCell: UITableViewCell, NibReusable {
    private struct Constant {
        static let cornerRadius = 10
    }
    
    @IBOutlet private var editButton: ImageButton!
    @IBOutlet private var deleteButton: ImageButton!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var imagePlaylist: ImageButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentForCell(viewController: UIViewController) {
        editButton.muttating(type: ImageButtonType.edit)
        editButton.setTintColorOfImage(color: .black)
        editButton.delegate = viewController as? ImageButtonDelegate
        deleteButton.muttating(type: ImageButtonType.delete)
        deleteButton.setTintColorOfImage(color: .black)
        deleteButton.delegate = viewController as? ImageButtonDelegate
        imagePlaylist.muttating(type: ImageButtonType.playlist)
        imagePlaylist.setTintColorOfImage(color: .white)
        imagePlaylist.layer.cornerRadius = CGFloat(Constant.cornerRadius)
    }
}
