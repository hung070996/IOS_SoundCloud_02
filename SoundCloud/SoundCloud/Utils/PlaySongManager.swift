//
//  PlaySongManager.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

enum PlayType {
    case online
    case offline
}

protocol PlaySongTimerDelegate: class {
    func startTimer(manager: PlaySongManager)
}

class PlaySongManager {
    static let shared = PlaySongManager()
    var type: PlayType = .online
    var player: AVPlayer?
    var currentList = [Track]()
    var timer = Timer()
    var isPlaying = false
    var currentTrack: Int?
    var playerItemContext = 0
    weak var delegate: PlaySongTimerDelegate?
    
    private init() {}
    
    func prepareToPlay(urlString: String, vc: UIViewController) {
        guard let url = URL(string: urlString) else {
            return
        }
        let asset = AVAsset(url: url)
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
        playerItem.addObserver(vc, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        player = AVPlayer(playerItem: playerItem)
    }
    
    func play(playButton: ImageButton) {
        guard let player = self.player else {
            return
        }
        player.play()
        isPlaying = true
        playButton.muttating(type: .pause)
    }
    
    func pause(playButton: ImageButton) {
        guard let player = self.player else {
            return
        }
        player.pause()
        isPlaying = false
        playButton.muttating(type: .play)
    }
    
    func startTimer() {
        if let delegate = self.delegate {
            delegate.startTimer(manager: self)
        }
    }
    
    func getCurrentTimePlaying() -> Double {
        guard let cmTime = self.player?.currentTime() else {
            return 0
        }
        return CMTimeGetSeconds(cmTime)
    }
}
