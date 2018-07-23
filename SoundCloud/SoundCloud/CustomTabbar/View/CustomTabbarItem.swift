//
//  CustomTabbarItem.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

enum CustomTabbarItemType: Int {
    case homePage = 1
    case search
    case library
    
    var image : UIImage{
        switch self {
        case .homePage:
            return #imageLiteral(resourceName: "Icon_Homepage")
        case .search:
            return #imageLiteral(resourceName: "Icon_Search")
        case .library:
            return #imageLiteral(resourceName: "Icon_Library")
        }
    }
}

class CustomTabbarItem: UIView, NibOwnerLoadable {

    @IBOutlet private weak var imvTabbarIcon: UIImageView!
    @IBOutlet private weak var viewHighlight: UIView!
    
    var type : CustomTabbarItemType!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.type = CustomTabbarItemType(rawValue: self.tag)
        self.loadNibContent()
    }
    
    override func awakeFromNib() {
        self.imvTabbarIcon.image = self.type.image
    }

    @IBAction func TabbarItemClicked(_ sender: Any) {
    }
}
