//
//  CustomTabbarViewController.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class CustomTabbarViewController: UIViewController {
    @IBOutlet private weak var tabbarItemHome: CustomTabbarItem!
    @IBOutlet private weak var tabbarItemSearch: CustomTabbarItem!
    @IBOutlet private weak var tabbarItemLibrary: CustomTabbarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbarDisplay()
    }

    func setTabbarDisplay() {
        tabbarItemHome.type = .homePage
        tabbarItemSearch.type = .search
        tabbarItemLibrary.type = .library
    }
}
