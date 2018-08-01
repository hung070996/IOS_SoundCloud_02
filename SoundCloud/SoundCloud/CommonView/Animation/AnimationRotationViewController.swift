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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setImageView(urlString: String) {
        let url = URL(string: urlString)
        let placeHolder = #imageLiteral(resourceName: "Icon_Playlist_Holder")
        imageViewDisplay.kf.setImage(with: url, placeholder: placeHolder)
    }
    
    func startAnimation() {
        imageViewDisplay.rotate360Degrees()
    }
    
    func stopAnimation() {
        imageViewDisplay.layer.removeAllAnimations()
    }
}
