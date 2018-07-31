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
        static let estimatedRowHeight = 100
        static let except = ["Download", "Favorite"]
        static let addNewPlaylist = "Add new playlist"
        static let inputName = "Input name"
        static let add = "Add"
        static let alreadyHave = "This name have already existed"
    }

    @IBOutlet private var titleView: TitleView!
    @IBOutlet private var tableView: UITableView!
    
    private var listPlaylist = [Playlist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setTableView()
        setTitleView()
    }
    
    func getData() {
        listPlaylist = DatabaseManager.shared.getListPlaylistCustom()
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
        let alert = UIAlertController(title: Constant.addNewPlaylist, message: Constant.inputName, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: Constant.add, style: .default, handler: { (action) in
            if let text = alert.textFields?.first?.text {
                if DatabaseManager.shared.checkExistPlaylist(name: text) {
                    self.showErrorAlert(message: Constant.alreadyHave)
                } else {
                    if DatabaseManager.shared.addPlaylist(name: text) {
                        print("Success")
                        self.getData()
                        self.tableView.reloadData()
                    } else {
                        print("Error")
                    }
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension PlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaylistCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(viewController: self, playlist: listPlaylist[indexPath.row])
        return cell
    }
}

extension PlaylistViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        
    }
}
