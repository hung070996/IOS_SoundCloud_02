//
//  CustomTabbarViewController.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Alamofire

class CustomTabbarViewController: UIViewController {
    @IBOutlet private weak var playContentView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var viewCurrentSongPlaying: CurrentSongPlaying!
    @IBOutlet private weak var tabbarItemHome: ImageButton!
    @IBOutlet private weak var tabbarItemSearch: ImageButton!
    @IBOutlet private weak var tabbarItemLibrary: ImageButton!
    private var currentViewControllerDisplay: UIViewController?
    private var previousViewControllerDisplay: UIViewController?
    private var arrViewController: [UIViewController]!
    private struct ViewControllerIndex {
        static let homepageIndex = 0
        static let searchIndex = 1
        static let libraryIndex = 2
        static let playIndex = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbarDisplay()
        setDelegate()
        setUpViewController()
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
        let homepageVC = Utils.shared.getViewControllerFrom(storyboard: .main, identifierType: .homepage) as! HomeViewController
        let searchVC = Utils.shared.getViewControllerFrom(storyboard: .main, identifierType: .search) as! SearchViewController
        let libraryVC = Utils.shared.getViewControllerFrom(storyboard: .main, identifierType: .library) as! LibraryViewController
        let playVC = Utils.shared.getViewControllerFrom(storyboard: .extra, identifierType: .play) as! PlaySongViewController
        playVC.delegate = self
        arrViewController = [homepageVC, searchVC, libraryVC, playVC]
        displayVC(vc: homepageVC)
        previousViewControllerDisplay = nil
        playContentView.isHidden = true
    }
    
    func removeVC(vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    func displayVC(vc: UIViewController) {
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
    }
    
    func pauseCurrentSong() {
        PlaySongManager.shared.pause(playButton: viewCurrentSongPlaying.getPlayButton())
    }
}

extension CustomTabbarViewController: PlaySongProtocol {
    func dismissToParent() {
        self.playContentView.isHidden = true
        removeVC(vc: arrViewController[ViewControllerIndex.playIndex])
    }
}

extension CustomTabbarViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        switch type {
        case .homePage:
            displayVC(vc: arrViewController[ViewControllerIndex.homepageIndex])
            setHighlightForCurrentButton(type: type)
            
        case .search:
            displayVC(vc: arrViewController[ViewControllerIndex.searchIndex])
            setHighlightForCurrentButton(type: type)
            
        case .library:
            displayVC(vc: arrViewController[ViewControllerIndex.libraryIndex])
            setHighlightForCurrentButton(type: type)
            
        case .playPrevious:
            displayVC(vc: arrViewController[ViewControllerIndex.playIndex])
            
        case .play:
            playCurrentSong()
            
        case .pause:
            pauseCurrentSong()
            
        default:
            fatalError()
        }
    }
}
