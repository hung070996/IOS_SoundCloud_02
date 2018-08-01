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

enum LoopType: Int {
    case none
    case single
    case all
    
    var image: UIImage {
        switch self {
        case .none, .all:
            return #imageLiteral(resourceName: "Icon_Loop")
        case .single:
            return #imageLiteral(resourceName: "Icon_Loop_One")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .none:
            return .white
        default:
            return .red
        }
    }
}

protocol PlaySongTimerDelegate: class {
    func startTimer(manager: PlaySongManager)
    func resetView()
    func stopAnimation()
    func startAnimation()
}

class PlaySongManager {
    static let shared = PlaySongManager()
    var type: PlayType = .online
    var player: AVPlayer?
    //hold the original list track
    var currentList = [Track]() {
        didSet {
            generateShuffleList()
        }
    }
    //hold the shuffled list
    var shuffleList = [Track]()
    var isPlaying = false
    var timer = Timer()
    var currentTrack: Track?
    var temproraryTrack: Track?
    var playerItemContext = 0
    var currentObserver: Any?
    var loopType = LoopType.none
    var isShuffle = false
    weak var delegate: PlaySongTimerDelegate?
    
    private struct ConstantData {
        static let baseStreamUrl = "http://api.soundcloud.com/tracks/"
        static let baseStreamTrail = "/stream?client_id="
    }
    
    private init() {}
    
    func playSongWithHandleVC(handleVC: UIViewController) {
        guard let track = temproraryTrack else {
            return
        }
        let resultChecking = checkItemInCurrentPlaylist(track: track, arr: currentList)
        if  resultChecking.result {
            if resultChecking.index == getCurrentTrackIndex() {
                //No need to reset view - just display
                return
            } else {
                currentTrack = currentList[resultChecking.index]
                prepareAVPlayerItem(handleVC: handleVC)
            }
            print("Song is existing .... ")
        } else { //play a new song
            currentList.append(track)
            currentTrack = temproraryTrack
            prepareAVPlayerItem(handleVC: handleVC)
        }
    }
    
    private func prepareAVPlayerItem(handleVC: UIViewController) {
        guard let track = self.currentTrack else {
            return
        }
        let urlString = getLinkStream(id: track.id)
        guard let url = URL(string: urlString) else {
            return
        }
        let asset = AVAsset(url: url)
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
        playerItem.addObserver(handleVC, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            return
        }
        if let observer = self.currentObserver {
            player?.removeTimeObserver(observer)
        }
        delegate?.resetView()
        playerItem.preferredForwardBufferDuration = 2
        player = AVPlayer(playerItem: playerItem)
    }
    
    func playNext(handleVC: UIViewController) {
        guard let track = currentTrack else {
            return
        }
        if isShuffle {
            let currentIndex = checkItemInCurrentPlaylist(track: track, arr: shuffleList).index
            currentTrack = currentIndex + 1 >= shuffleList.count ? shuffleList[0] : shuffleList[currentIndex + 1]
        } else {
            let currentIndex = checkItemInCurrentPlaylist(track: track, arr: currentList).index
            currentTrack = currentIndex + 1 >= currentList.count ? currentList[0] : currentList[currentIndex + 1]
        }
        prepareAVPlayerItem(handleVC: handleVC)
    }
    
    func playFirstItem(handlVC: UIViewController) {
        currentTrack = currentList[0]
        prepareAVPlayerItem(handleVC: handlVC)
    }
    
    func playPrevious(handleVC: UIViewController) {
        guard let track = currentTrack else {
            return
        }
        if isShuffle {
            let currentIndex = checkItemInCurrentPlaylist(track: track, arr: shuffleList).index
            currentTrack = currentIndex - 1 < 0 ? shuffleList[0] : shuffleList[currentIndex - 1]
        } else {
            let currentIndex = checkItemInCurrentPlaylist(track: track, arr: currentList).index
            currentTrack = currentIndex - 1 < 0 ? currentList[0] : currentList[currentIndex - 1]
        }
        prepareAVPlayerItem(handleVC: handleVC)
    }
    
    func play(playButton: ImageButton) {
        guard let player = self.player else {
            return
        }
        player.play()
        isPlaying = true
        delegate?.startAnimation()
        playButton.muttating(type: .pause)
    }
    
    func pause(playButton: ImageButton) {
        guard let player = self.player else {
            return
        }
        player.pause()
        isPlaying = false
        playButton.muttating(type: .play)
        delegate?.stopAnimation()
    }
    
    func generateShuffleList(){
        shuffleList = currentList
        for last in (0..<shuffleList.count).reversed() {
            let rand = Int(arc4random_uniform(UInt32(last)))
            shuffleList.swapAt(last, rand)
        }
    }
    
    func changeLoopStatus(button: ImageButton) {
        var nextStatus = self.loopType.rawValue + 1
        nextStatus = nextStatus > LoopType.all.rawValue ? 0 : nextStatus
        if let nextLoopType = LoopType.init(rawValue: nextStatus) {
            loopType = nextLoopType
        }
        button.setLoopButtonDisplay(loopType: loopType)
    }
    
    func startTimer() {
        delegate?.startTimer(manager: self)
    }
    
    func getLinkStream(id: Int) -> String {
        return ConstantData.baseStreamUrl + String(id) + ConstantData.baseStreamTrail + APIKey.clientID
    }
    
    func getCurrentTimePlaying() -> Double {
        guard let cmTime = self.player?.currentTime() else {
            return 0
        }
        return CMTimeGetSeconds(cmTime)
    }
    
    func getCurrentTrackIndex() -> Int {
        guard let currentTrack = self.currentTrack else {
            return -1
        }
        for index in 0..<currentList.count {
            if currentList[index].id == currentTrack.id {
                return index
            }
        }
        return -1
    }
    
    func checkItemInCurrentPlaylist(track: Track, arr: [Track]) -> (result: Bool, index: Int) {
        for index in 0..<arr.count {
            if arr[index].id == track.id {
                return (true, index)
            }
        }
        return (false, 0)
    }
}
