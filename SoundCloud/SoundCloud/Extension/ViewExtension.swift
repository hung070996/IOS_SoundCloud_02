//
//  ViewExtension.swift
//  SoundCloud
//
//  Created by Do Hung on 8/3/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func getShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 3, height: -3)
        layer.shadowRadius = 5
    }
}
