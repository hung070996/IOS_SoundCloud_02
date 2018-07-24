//
//  TitleView.swift
//  SoundCloud
//
//  Created by Do Hung on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class TitleView: UIView, NibOwnerLoadable {
    @IBOutlet private var leftButton: ImageButton!
    @IBOutlet private var mainTitleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    func setTitle(title: String) {
        mainTitleLabel.text = title
    }
    
    func setButton(type: ImageButtonType) {
        leftButton.muttating(type: type)
    }
    
    func setShowLeftButton(isShow: Bool) {
        leftButton.isHidden = !isShow
    }
}
