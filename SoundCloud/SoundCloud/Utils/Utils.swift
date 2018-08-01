//
//  Utils.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/26/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import UIKit

enum StoryBoardType: String {
    case main = "Main"
    case extra = "Extra"
}

enum IdentifierType: String {
    case homepage = "HomeViewController"
    case search = "SearchViewController"
    case library = "LibraryViewController"
    case play = "PlaySongViewController"
    case rotationImageView = "AnimationRotationViewController"
    case currentPlaylistPlaying = "CurrentPlaylistViewController"
    case songPlayingCollectionCell = "SongPlayingCollectionViewCell"
    case customTabbar = "CustomTabbarViewController"
    case libraryNavigation = "LibraryNavigation"
    case homeNavigation = "HomeNavigation"
}

class Utils {
    static let shared = Utils()
    
    private init() {}
    
    private struct UtilsConstant {
        static let countTimeFormat = "%02d:%02d"
        static let countTimeFormatWithHour = "%2d:%2d:%2d"
        static let secondsPerHour = 3600
        static let secondsPerMinute = 60
        static let milisecondsPerSecond = 1000
    }
    
    func formatDurationTime(time: Int) -> String {
        var tmpTime = time
        let hours = tmpTime / UtilsConstant.secondsPerHour
        tmpTime -= hours * UtilsConstant.secondsPerHour
        let minutes = tmpTime / UtilsConstant.secondsPerMinute
        tmpTime -= minutes * UtilsConstant.secondsPerMinute
        let seconds = tmpTime
        if hours <= 0 {
            return String(format: UtilsConstant.countTimeFormat, minutes, seconds)
        } else {
            return String(format: UtilsConstant.countTimeFormatWithHour, hours, minutes, seconds)
        }
    }
    
    func getViewControllerFrom(storyboard: StoryBoardType, identifierType: IdentifierType) -> UIViewController {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifierType.rawValue)
    }
}
