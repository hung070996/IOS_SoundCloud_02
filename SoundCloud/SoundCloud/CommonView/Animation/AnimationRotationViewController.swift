//
//  AnimationRotationViewController.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/30/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//
import UIKit
import Kingfisher

class AnimationRotationViewController: UIViewController {
    @IBOutlet private weak var imageViewDisplay: UIImageView!
    var isAnimating = false
    
    private struct ConstantData {
        static let holderImage = #imageLiteral(resourceName: "Icon_Playlist_Holder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setImageView(urlString: String) {
        imageViewDisplay.layer.cornerRadius = imageViewDisplay.bounds.width / 2
        imageViewDisplay.layer.masksToBounds = true
        imageViewDisplay.setImageForUrl(urlString: urlString, imageHolder: ConstantData.holderImage)
    }
    
    func startAnimation() {
        isAnimating = true
        imageViewDisplay.rotate360Degrees()
    }
    
    func stopAnimation() {
        isAnimating = false
        imageViewDisplay.layer.removeAllAnimations()
    }
}
