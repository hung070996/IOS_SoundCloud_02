//
//  CustomTabbarItem.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

enum ImageButtonType {
    case homePage
    case search
    case library
    case love
    case download
    case share
    case addToPlaylist
    case minimize
    case displayCurrentPlaylist
    case displayCurrentSong
    case exit
    case back
    case edit
    case delete
    case playPrevious
    case play
    case playNext
    case shuffle
    case loop
    case playlist
    
    var image: UIImage {
        switch self {
        case .homePage:
            return #imageLiteral(resourceName: "Icon_Homepage")
        case .search:
            return #imageLiteral(resourceName: "Icon_Search")
        case .library:
            return #imageLiteral(resourceName: "Icon_Library")
        case .love:
            return #imageLiteral(resourceName: "Icon_Love")
        case .download:
            return #imageLiteral(resourceName: "Icon_Download")
        case .share:
            return #imageLiteral(resourceName: "Icon_Share")
        case .addToPlaylist:
            return #imageLiteral(resourceName: "Icon_Add_To_Playlist")
        case .minimize:
            return #imageLiteral(resourceName: "Icon_Minimize_Down")
        case .displayCurrentPlaylist:
            return #imageLiteral(resourceName: "Icon_Current_Playlist")
        case .displayCurrentSong, .play:
            return #imageLiteral(resourceName: "Icon_Play")
        case .playPrevious:
            return #imageLiteral(resourceName: "Icon_Play_Previous")
        case .playNext:
            return #imageLiteral(resourceName: "Icon_Play_Next")
        case .shuffle:
            return #imageLiteral(resourceName: "Icon_Shuffle")
        case .loop:
            return #imageLiteral(resourceName: "Icon_Loop")
        case .delete:
            return #imageLiteral(resourceName: "Icon_Delete")
        case .edit:
            return #imageLiteral(resourceName: "Icon_Edit")
        case .back:
            return #imageLiteral(resourceName: "Icon_Minimize_Down")
        case .playlist:
            return #imageLiteral(resourceName: "Icon_Playlist_Holder")
        default:
            return #imageLiteral(resourceName: "Icon_Playlist_Holder")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .download:
            return .gray
        case .homePage, .search, .library:
            return .black
        default:
            return .white
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .homePage, .search, .library, .play, .playNext, .playPrevious:
            return 2/3
        default:
            return 1/2
        }
    }
}

protocol ImageButtonDelegate: class {
    func handleImageButtonClicked(type: ImageButtonType)
}

class ImageButton: UIView, NibOwnerLoadable {
    @IBOutlet private weak var imvIcon: UIImageView!
    @IBOutlet private weak var viewHighlight: UIView!
    @IBOutlet private weak var constraintMultiplerOfImage: NSLayoutConstraint!
    private var type: ImageButtonType!
    weak var delegate: ImageButtonDelegate?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
        self.type = .homePage
    }
    
    override func awakeFromNib() {
        setImageDisplay()
        self.setHighlightView(isHidden: true)
    }
    
    private func setImageDisplay() {
        self.imvIcon.image = self.type.image.withRenderingMode(.alwaysTemplate)
    }
    
    func setHighlightView(isHidden: Bool) {
        self.viewHighlight.isHidden = isHidden
    }
    
    func setMultipleOfImage(scale: CGFloat) {
        self.constraintMultiplerOfImage = self.constraintMultiplerOfImage.changeMultiplier(multiplier: scale)
    }
    
    func setTintColorOfImage(color: UIColor) {
        self.imvIcon.tintColor = color
    }
    
    func muttating(type: ImageButtonType) {
        self.type = type
        setImageDisplay()
        setMultipleOfImage(scale: self.type.scale)
        setTintColorOfImage(color: self.type.tintColor)
    }

    @IBAction func imageButtonClicked(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.handleImageButtonClicked(type: self.type)
        }
    }
}

extension NSLayoutConstraint {
    func changeMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        newConstraint.priority = priority
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
