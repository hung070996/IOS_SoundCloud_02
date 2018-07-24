//
//  CustomTabbarViewController.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class CustomTabbarViewController: UIViewController {
    @IBOutlet private weak var tabbarItemHome: ImageButton!
    @IBOutlet private weak var tabbarItemSearch: ImageButton!
    @IBOutlet private weak var tabbarItemLibrary: ImageButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbarDisplay()
        setDelegate()
    }
    
    func setTabbarDisplay() {
        tabbarItemHome.muttating(type: .homePage)
        tabbarItemSearch.muttating(type: .search)
        tabbarItemLibrary.muttating(type: .library)
        tabbarItemHome.setHighlightView(isHidden: false)
    }
    
    func setDelegate() {
        [tabbarItemHome, tabbarItemSearch, tabbarItemLibrary].forEach { (button) in
            button?.delegate = self
        }
    }
}

extension CustomTabbarViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        print("Type: \(type)")
    }
}
