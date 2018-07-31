//
//  PlaySongViewController.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlaySongProtocol: class {
    func dismissToParent()
}

class PlaySongViewController: UIViewController {
    @IBOutlet private weak var durationTimeLabel: UILabel!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var sliderCountTime: UISlider!
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
    @IBOutlet private weak var collectionViewDisplay: UICollectionView!
    weak var delegate: PlaySongProtocol?
    var playerItem: AVPlayerItem?
    var viewcontrollersContent: [UIViewController]?
    private struct ConstantData {
        static let songUrl = "http://api.soundcloud.com/tracks/371985497/stream?client_id=AJ4pxoFBchG36bmDxD5VwWzwlpDDbuYE"
        static let songDuration = 170
        static let numberOfItemCell = 2
        static let indexItemAnimationView = 0
        static let indexItemCurrentPlaylist = 1
        static let zero = 0
        static let one = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageButtonDisplay()
        setDelegate()
        setUpAVPlayer()
        setUpViewController()
    }
    
    private func setUpViewController() {
        guard let animationVC = Utils.shared.getViewControllerFrom(storyboard: .extra, identifierType: .rotationImageView) as? AnimationRotationViewController,
            let listSongVC = Utils.shared.getViewControllerFrom(storyboard: .extra, identifierType: .currentPlaylistPlaying) as? CurrentPlaylistViewController
            else {
                //alert inform the error
                return
        }
        viewcontrollersContent = [animationVC, listSongVC]
        viewcontrollersContent?.forEach({ (vc) in
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
        })
    }
    
    private func setUpAVPlayer() {
        //using template data
        self.durationTimeLabel.text = Utils.shared.formatDurationTime(time: ConstantData.songDuration)
        PlaySongManager.shared.delegate = self
        let str = ConstantData.songUrl
        guard let url = URL(string: str) else {
            //alert inform the error
            return
        }
        playerItem = AVPlayerItem(url: url)
        PlaySongManager.shared.prepareToPlay(urlString: ConstantData.songUrl, vc: self)
        sliderCountTime.addTarget(self, action: #selector(handleActionSlider(sender:event:)), for: UIControlEvents.allEvents)
        sliderCountTime.setValue(Float(ConstantData.zero), animated: false)
    }

    private func setImageButtonDisplay() {
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
    
    private func setDelegate() {
        [ibMinimize, ibCurrentPlaylist, ibAddToPlaylist, ibShare, ibDownload, ibLike, ibShuffle, ibPlayNext, ibPlayPrevious, ibPlay, ibLoop].forEach { (button) in
            button?.delegate = self
        }
    }
    
    @objc func handleActionSlider(sender: AnyObject, event: UIEvent) {
        if let handleEvent = event.allTouches?.first {
            switch handleEvent.phase {
            case .began:
                PlaySongManager.shared.pause(playButton: ibPlay)
            case .ended:
                guard let player = PlaySongManager.shared.player,
                    let item = player.currentItem else {
                    return
                }
                let value = (sliderCountTime.value * Float(ConstantData.songDuration))
                let timeInterval = CMTime(seconds: Double(value), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                item.seek(to: timeInterval)
                player.play()
            default:
                break
            }
        }
    }
    
    func play() {
        if PlaySongManager.shared.player?.currentItem?.status == AVPlayerItemStatus.readyToPlay {
            PlaySongManager.shared.play(playButton: ibPlay)
        } else {
            fatalError()
        }
    }
    
    func pause() {
        PlaySongManager.shared.pause(playButton: ibPlay)
    }
    
    func displayCurrentButtonHandle() {
        if ibCurrentPlaylist.getType() == .displayCurrentPlaylist {
            collectionViewDisplay.scrollToItem(at: IndexPath(item: ConstantData.indexItemCurrentPlaylist, section: ConstantData.zero), at: .left, animated: true)
            ibCurrentPlaylist.muttating(type: .displayCurrentSong)
        } else {
            collectionViewDisplay.scrollToItem(at: IndexPath(item: ConstantData.indexItemAnimationView, section: ConstantData.zero), at: .left, animated: true)
            ibCurrentPlaylist.muttating(type: .displayCurrentPlaylist)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            if let statusNumber = change?[.newKey] as? NSNumber, let newStatus = AVPlayerItemStatus(rawValue: statusNumber.intValue) {
                status = newStatus
            } else {
                status = .unknown
            }
            switch status {
            case .readyToPlay:
                PlaySongManager.shared.play(playButton: ibPlay)
                PlaySongManager.shared.startTimer()
            case .failed:
                return
            case .unknown:
                return
            }
        }
    }
}

extension PlaySongViewController: PlaySongTimerDelegate {
    func startTimer(manager: PlaySongManager) {
        let interval = CMTime(seconds: ConstantData.one, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        guard let player = manager.player,
            let duration = player.currentItem?.asset.duration else {
            return
        }
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            let timeInt = Int(CMTimeGetSeconds(time))
            let str = Utils.shared.formatDurationTime(time: timeInt)
            self?.currentTimeLabel.text = str
            self?.sliderCountTime.setValue(Float(time.seconds / duration.seconds), animated: true)
            if time.seconds / duration.seconds >= ConstantData.one {
                //decide for next Action or loop - current is auto loop
                player.currentItem?.seek(to: kCMTimeZero)
                player.play()
            }
        }
    }
}

extension PlaySongViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        switch type {
        case .play:
            play()
            
        case .pause:
            pause()
            
        case .minimize:
            if let delegate = self.delegate {
                delegate.dismissToParent()
            }
            
        case .displayCurrentPlaylist, .displayCurrentSong:
            displayCurrentButtonHandle()
            
        default:
            fatalError()
        }
    }
}

extension PlaySongViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ConstantData.numberOfItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdentifierType.songPlayingCollectionCell.rawValue, for: indexPath)
        if let arrViewController = viewcontrollersContent {
            cell.contentView.addSubview(arrViewController[indexPath.row].view)
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let first = collectionViewDisplay.indexPathsForVisibleItems.first else {
            return
        }
        if first.item == ConstantData.indexItemAnimationView {
            ibCurrentPlaylist.muttating(type: .displayCurrentPlaylist)
        } else {
            ibCurrentPlaylist.muttating(type: .displayCurrentSong)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.contentSize.height)
    }
}
