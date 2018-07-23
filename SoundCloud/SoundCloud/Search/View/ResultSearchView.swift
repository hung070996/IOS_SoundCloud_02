//
//  ResultSearchView.swift
//  SoundCloud
//
//  Created by Do Hung on 7/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class ResultSearchView: UIView, NibOwnerLoadable {
    @IBOutlet private var resultTableView: UITableView!
    @IBOutlet private var numberResultLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    func getTable() -> UITableView {
        return self.resultTableView
    }
    
    func setContentTableview (viewController: UIViewController) {
        resultTableView.delegate = viewController as? UITableViewDelegate
        resultTableView.dataSource = viewController as? UITableViewDataSource
        resultTableView.register(cellType: ResultSearchCell.self)
    }
}
