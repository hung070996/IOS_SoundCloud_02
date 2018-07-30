//
//  ListSongViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class ListSongViewController: UIViewController {
    private struct Constant {
        static let title = "List Song"
        static let estimatedRowHeight = 100
        static let numberOfCell = 10
    }
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var titleView: TitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setTitleView()
    }
    
    func setTableView() {
        tableView.register(cellType: ResultSearchCell.self)
        tableView.estimatedRowHeight = CGFloat(Constant.estimatedRowHeight)
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setTitleView() {
        titleView.setTitle(title: Constant.title)
        titleView.setButton(type: .back)
    }
}

extension ListSongViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultSearchCell = tableView.dequeueReusableCell(for: indexPath)
//        cell.setContentForCell(viewController: self)
        cell.setShowDownloadButton(isShow: false)
        return cell
    }
}

extension ListSongViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        print(type)
    }
}
