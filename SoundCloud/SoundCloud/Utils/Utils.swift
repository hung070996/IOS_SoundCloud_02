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
        static let color = "#FDBC46"
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
    
    func listFilesFromDocumentsFolder() -> [String]? {
        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        return try? fileManager.contentsOfDirectory(atPath:docs)
    }
    
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getBaseColor() -> UIColor {
        return hexStringToUIColor(hex: UtilsConstant.color)
    }
}
