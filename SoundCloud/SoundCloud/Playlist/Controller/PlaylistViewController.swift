//
//  PlaylistViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    private struct Constant {
        static let title = "Playlist"
        static let numberOfPlaylist = 3
        static let numberOfCellInOneScreen = 10
        static let estimatedRowHeight = 100
    }

    @IBOutlet private var titleView: TitleView!
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setTitleView()
    }
    
    func setTableView() {
        tableView.register(cellType: PlaylistCell.self)
        tableView.estimatedRowHeight = CGFloat(Constant.estimatedRowHeight)
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setTitleView() {
        titleView.setTitle(title: Constant.title)
        titleView.setButton(type: .back)
    }
    
    @IBAction func clickAddPlaylist(_ sender: Any) {
    }
}

extension PlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfPlaylist
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaylistCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(viewController: self)
        return cell
    }
}

extension PlaylistViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        print(type)
    }
}
