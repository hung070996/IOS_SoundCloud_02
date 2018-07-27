//
//  ButtonExtension.swift
//  SoundCloud
//
//  Created by Do Hung on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func getRoundOnHeight() {
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}
