//
//  CustomTabbarViewController.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Alamofire

protocol CustomTabbarDelegate: class {
    func requestPlaySong()
}

enum ViewControllerContentType: Int {
    case homepage
    case search
    case library
    case play
}

class CustomTabbarViewController: UIViewController {
    @IBOutlet private weak var playContentView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var viewCurrentSongPlaying: CurrentSongPlaying!
    @IBOutlet private weak var tabbarItemHome: ImageButton!
    @IBOutlet private weak var tabbarItemSearch: ImageButton!
    @IBOutlet private weak var tabbarItemLibrary: ImageButton!
    weak var delegate: CustomTabbarDelegate?
    private var currentViewControllerDisplay: UIViewController?
    private var previousViewControllerDisplay: UIViewController?
    private var arrViewController: [UIViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setTabbarDisplay()
        setDelegate()
        NotificationCenter.default.addObserver(self, selector: #selector(requestPlaySong), name: NSNotification.Name.init("PlaySong"), object: nil)
        viewCurrentSongPlaying.isHidden = true
    }
    
    private func setTabbarDisplay() {
        tabbarItemHome.muttating(type: .homePage)
        tabbarItemSearch.muttating(type: .search)
        tabbarItemLibrary.muttating(type: .library)
        tabbarItemHome.setHighlightView(isHidden: false)
    }
    
    private func setDelegate() {
        [tabbarItemHome, tabbarItemSearch, tabbarItemLibrary].forEach { (button) in
            button?.delegate = self
        }
        viewCurrentSongPlaying.setDelegate(vc: self)
    }
    
    private func setUpViewController() {
        guard let homeNavi = Utils.shared.getViewControllerFrom(storyboard: .main, identifierType: .homeNavigation) as? UINavigationController,
            let libraryNavi = Utils.shared.getViewControllerFrom(storyboard: .main, identifierType: .libraryNavigation) as? UINavigationController,
            let searchVC = Utils.shared.getViewControllerFrom(storyboard: .main, identifierType: .search) as? SearchViewController,
            let playVC = Utils.shared.getViewControllerFrom(storyboard: .extra, identifierType: .play) as? PlaySongViewController else {
            return
        }
        playVC.delegate = self
        self.delegate = playVC
        arrViewController = [homeNavi, searchVC, libraryNavi, playVC]
        displayVC(type: .homepage)
        previousViewControllerDisplay = nil
        playContentView.isHidden = true
    }
    
    func removeVC(vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    func displayVC(type: ViewControllerContentType) {
        let vc = arrViewController[type.rawValue]
        if let previousVC = previousViewControllerDisplay {
            removeVC(vc: previousVC)
        }
        addChildViewController(vc)
        if vc is PlaySongViewController {
            vc.view.frame = playContentView.bounds
            playContentView.addSubview(vc.view)
            playContentView.isHidden = false
        } else {
            vc.view.frame = contentView.bounds
            contentView.addSubview(vc.view)
        }
        vc.didMove(toParentViewController: self)
        currentViewControllerDisplay = vc
    }
    
    func setHighlightForCurrentButton(type: ImageButtonType) {
        [tabbarItemHome, tabbarItemSearch, tabbarItemLibrary].forEach { (button) in
            if button?.getType() == type {
                button?.setHighlightView(isHidden: false)
            } else {
                button?.setHighlightView(isHidden: true)
            }
        }
    }
    
    func playCurrentSong() {
        PlaySongManager.shared.play(playButton: viewCurrentSongPlaying.getPlayButton())
        viewCurrentSongPlaying.startAnimation()
    }
    
    func pauseCurrentSong() {
        PlaySongManager.shared.pause(playButton: viewCurrentSongPlaying.getPlayButton())
        viewCurrentSongPlaying.stopAnimation()
    }
    
    func updateViewCurrentSongPlaying() {
        guard let track = PlaySongManager.shared.currentTrack else {
            return
        }
        viewCurrentSongPlaying.fillData(track: track)
        PlaySongManager.shared.isPlaying ? startAnimationOfViewSongCurrentPlaying() : stopAnimationOfViewSongCurrentPlaying()
    }
    
    private func startAnimationOfViewSongCurrentPlaying() {
        viewCurrentSongPlaying.startAnimation()
        viewCurrentSongPlaying.getPlayButton().muttating(type: .pause)
    }
    
    private func stopAnimationOfViewSongCurrentPlaying() {
        viewCurrentSongPlaying.stopAnimation()
        viewCurrentSongPlaying.getPlayButton().muttating(type: .play)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func requestPlaySong() {
        displayVC(type: .play)
        if let delegate = self.delegate {
            delegate.requestPlaySong()
        }
    }
}

extension CustomTabbarViewController: CurrentSongPlayingDelegate {
    func displayPlaySongViewController() {
        displayVC(type: .play)
    }
}

extension CustomTabbarViewController: PlaySongProtocol {
    func dismissToParent() {
        self.playContentView.isHidden = true
        self.viewCurrentSongPlaying.isHidden = false
        removeVC(vc: arrViewController[ViewControllerContentType.play.rawValue])
        updateViewCurrentSongPlaying()
    }
}

extension CustomTabbarViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        guard let playVC = arrViewController[ViewControllerContentType.play.rawValue] as? PlaySongViewController else {
            return
        }
        switch type {
        case .homePage:
            displayVC(type: .homepage)
            setHighlightForCurrentButton(type: type)
            
        case .search:
            displayVC(type: .search)
            setHighlightForCurrentButton(type: type)
            
        case .library:
            displayVC(type: .library)
            setHighlightForCurrentButton(type: type)
            
        case .play:
            playCurrentSong()
            
        case .pause:
            pauseCurrentSong()
            
        case .playNext:
            PlaySongManager.shared.playNext(handleVC: playVC)
            updateViewCurrentSongPlaying()
            
        case .playPrevious:
            PlaySongManager.shared.playPrevious(handleVC: playVC)
            updateViewCurrentSongPlaying()
            
        default:
            fatalError()
        }
    }
}
