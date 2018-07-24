//
//  PlaySongViewController.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class PlaySongViewController: UIViewController {
    @IBOutlet private weak var ibMinimize: ImageButton!
    @IBOutlet private weak var ibCurrentPlaylist: ImageButton!
    @IBOutlet private weak var ibLike: ImageButton!
    @IBOutlet private weak var ibDownload: ImageButton!
    @IBOutlet private weak var ibShare: ImageButton!
    @IBOutlet private weak var ibAddToPlaylist: ImageButton!
    @IBOutlet private weak var ibShuffle: ImageButton!
    @IBOutlet private weak var ibPlayPrevious: ImageButton!
    @IBOutlet private weak var ibPlay: ImageButton!
    @IBOutlet private weak var ibPlayNext: ImageButton!
    @IBOutlet private weak var ibLoop: ImageButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageButtonDisplay()
        setDelegate()
    }

    func setImageButtonDisplay() {
        ibMinimize.muttating(type: .minimize)
        ibCurrentPlaylist.muttating(type: .displayCurrentPlaylist)
        ibLike.muttating(type: .love)
        ibDownload.muttating(type: .download)
        ibShare.muttating(type: .share)
        ibAddToPlaylist.muttating(type: .addToPlaylist)
        ibPlay.muttating(type: .play)
        ibPlayNext.muttating(type: .playNext)
        ibPlayPrevious.muttating(type: .playPrevious)
        ibShuffle.muttating(type: .shuffle)
        ibLoop.muttating(type: .loop)
    }
    
    func setDelegate() {
        [ibMinimize, ibCurrentPlaylist, ibAddToPlaylist, ibShare, ibDownload, ibLike, ibShuffle, ibPlayNext, ibPlayPrevious, ibPlay, ibLoop].forEach { (button) in
            button?.delegate = self
        }
    }
}

extension PlaySongViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        print("Type: \(type)")
    }
}
