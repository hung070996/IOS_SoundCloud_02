//
//  ViewControllerExtension.swift
//  SoundCloud
//
//  Created by Do Hung on 7/26/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import UIKit
import SpringIndicator

extension UIViewController {
    private struct Constant {
        static let sizeLoading: CGFloat = 50
    }
    
    var indicator: SpringIndicator {
        let indicator = SpringIndicator()
        indicator.frame.size.width = Constant.sizeLoading
        indicator.frame.size.height = Constant.sizeLoading
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.start()
        return indicator
    }
}
