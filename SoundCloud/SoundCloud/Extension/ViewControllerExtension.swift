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
        static let error = "Error"
        static let ok = "OK"
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
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: Constant.error, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constant.ok, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for action in actions { alert.addAction(action) }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTextfield(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func makeToastWindow(title: String) {
        let window = UIApplication.shared.keyWindow
        window?.rootViewController?.view.makeToast(title)
    }
}
