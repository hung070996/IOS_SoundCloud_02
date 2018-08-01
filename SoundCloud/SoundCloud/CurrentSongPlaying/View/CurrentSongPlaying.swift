//
//  CurrentSongPlaying.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

protocol CurrentSongPlayingDelegate: class {
    func displayPlaySongViewController()
}

class CurrentSongPlaying: UIView, NibOwnerLoadable {
    @IBOutlet private weak var imgViewDisplay: UIImageView!
    @IBOutlet private weak var lblSinger: UILabel!
    @IBOutlet private weak var lblNameOfSong: UILabel!
    @IBOutlet private weak var ibPlayNext: ImageButton!
    @IBOutlet private weak var ibPlay: ImageButton!
    @IBOutlet private weak var ibPlayPrevious: ImageButton!
    @IBOutlet private weak var viewImgaeHolder: UIView!
    weak var delegate: CurrentSongPlayingDelegate?
    
    private struct ConstantData {
        static let scaleButton = CGFloat(1.0/2)
        static let imageHolder = #imageLiteral(resourceName: "Icon_Playlist_Holder")
    }
    
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
            button?.setMultipleOfImage(scale: ConstantData.scaleButton)
        }
        viewImgaeHolder.backgroundColor = .clear
    }
    
    func startAnimation() {
        imgViewDisplay.rotate360Degrees()
    }
    
    func stopAnimation() {
        imgViewDisplay.layer.removeAllAnimations()
    }
    
    func setDelegate(vc: UIViewController) {
        if let vc = vc as? ImageButtonDelegate{
            [ibPlayNext, ibPlay, ibPlayPrevious].forEach { (button) in
                button?.delegate = vc
            }
        }
        if let vc = vc as? CurrentSongPlayingDelegate {
            self.delegate = vc
        }
    }
    
    func fillData(track: Track) {
        lblSinger.text = track.artist
        lblNameOfSong.text = track.title
        imgViewDisplay.layer.cornerRadius = imgViewDisplay.bounds.width / 2
        imgViewDisplay.layer.masksToBounds = true
        imgViewDisplay.setImageForUrl(urlString: track.urlImage, imageHolder: ConstantData.imageHolder)
    }
    
    func getPlayButton() -> ImageButton {
        return ibPlay
    }
    
    @IBAction func buttonBackgourndClicked(_ sender: UIButton) {
        delegate?.displayPlaySongViewController()
    }
}
