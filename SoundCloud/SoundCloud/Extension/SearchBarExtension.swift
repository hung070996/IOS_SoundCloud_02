//
//  SearchBarExtension.swift
//  SoundCloud
//
//  Created by Do Hung on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    private struct Constant {
        static let scale: CGFloat = 0.7
        static let ratio: CGFloat = 2
    }
    
    public var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    
    public var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.flatMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: Constant.scale, y: Constant.scale)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = .white
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width / Constant.ratio, y: leftViewSize.height / Constant.ratio)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
