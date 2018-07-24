//
//  SuggestionSearchView.swift
//  SoundCloud
//
//  Created by Do Hung on 7/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

protocol SuggestionSearchViewDelegate: class {
    func clickHotButton(title: String?)
}

class SuggestionSearchView: UIView, NibOwnerLoadable {
    weak var delegate: SuggestionSearchViewDelegate?
    @IBOutlet private var historyTableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    func getTable() -> UITableView {
        return self.historyTableView
    }
    
    func setContentTableView(viewController: UIViewController) {
        historyTableView.register(cellType: HistorySearchCell.self)
        historyTableView.delegate = viewController as? UITableViewDelegate
        historyTableView.dataSource = viewController as? UITableViewDataSource
    }
    
    @IBAction func clickHotButton(_ sender: UIButton) {
        delegate?.clickHotButton(title: sender.titleLabel?.text)
    }
}
