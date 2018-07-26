//
//  CurrentSongPlaying.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class CurrentSongPlaying: UIView, NibOwnerLoadable {
    @IBOutlet private weak var lblSinger: UILabel!
    @IBOutlet private weak var lblNameOfSong: UILabel!
    @IBOutlet private weak var ibPlayNext: ImageButton!
    @IBOutlet private weak var ibPlay: ImageButton!
    @IBOutlet private weak var ibPlayPrevious: ImageButton!
    @IBOutlet private weak var viewImgaeHolder: UIView!
    private let SCALE_BUTTON = CGFloat(1.0/2)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
        setImageButtonDisplay()
    }
    
    func setImageButtonDisplay() {
        ibPlayNext.muttating(type: .playNext)
        ibPlayPrevious.muttating(type: .playPrevious)
        ibPlay.muttating(type: .play)
        [ibPlayNext, ibPlay, ibPlayPrevious].forEach { (button) in
            button?.setMultipleOfImage(scale: SCALE_BUTTON)
        }
    }
    
    func setDelegate(vc: UIViewController) {
        if let vc = vc as? ImageButtonDelegate{
            [ibPlayNext, ibPlay, ibPlayPrevious].forEach { (button) in
                button?.delegate = vc
            }
        }
    }
    
    func getPlayButton() -> ImageButton {
        return ibPlay
    }
}
