//
//  PlaylistViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Toast_Swift

class PlaylistViewController: UIViewController {
    private struct Constant {
        static let title = "Playlist"
        static let estimatedRowHeight = 100
        static let except = ["Download", "Favorite"]
        static let addNewPlaylist = "Add new playlist"
        static let renamePlaylist = "Rename playlist"
        static let inputName = "Input name"
        static let add = "Add"
        static let cancel = "Cancel"
        static let rename = "Rename"
        static let alreadyHave = "This name have already existed"
        static let yes = "Yes"
        static let no = "No"
        static let success = "Success"
        static let failure = "Failure"
        static let confirm = "Confirm"
        static let confirmDelete = "Do you want to delete this playlist?"
        static let main = "Main"
        static let listSongViewController = "ListSongViewController"
    }

    @IBOutlet private var titleView: TitleView!
    @IBOutlet private var tableView: UITableView!
    
    var listPlaylist = [Playlist]()
    var trackWantToAdd: Track?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        getData()
        setTableView()
        setTitleView()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name.init("refresh"), object: nil)
    }
    
    @objc func getData() {
        listPlaylist = DatabaseManager.shared.getListPlaylistCustom()
        tableView.reloadData()
    }
    
    func setTableView() {
        tableView.register(cellType: PlaylistCell.self)
        tableView.estimatedRowHeight = CGFloat(Constant.estimatedRowHeight)
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setTitleView() {
        titleView.setTitle(title: Constant.title)
        titleView.setButton(type: .back)
        titleView.setDelegateForButton(viewController: self)
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
                        self.view.makeToast(Constant.success)
                        self.getData()
                        self.tableView.reloadData()
                    } else {
                        self.view.makeToast(Constant.failure)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: Constant.cancel, style: .cancel, handler: nil))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let track = trackWantToAdd else {
            let storyboard = UIStoryboard(name: Constant.main, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: Constant.listSongViewController) as? ListSongViewController {
                vc.playlist = listPlaylist[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        if DatabaseManager.shared.addTrack(track: track) && DatabaseManager.shared.addTrackToPlaylist(track: track, idPlaylist: listPlaylist[indexPath.row].getID()) {
            makeToastWindow(title: Constant.success)
            dismiss(animated: true, completion: nil)
        } else {
            view.makeToast(Constant.failure)
        }
    }
}

extension PlaylistViewController: PlaylistCellDelegate {
    func clickImageButton(type: ImageButtonType, cell: PlaylistCell) {
        guard let index = tableView.indexPath(for: cell) else {
            return
        }
        let playlist = listPlaylist[index.row]
        switch type {
        case .edit:
            let alert = UIAlertController(title: Constant.renamePlaylist, message: Constant.inputName, preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField { (textfield) in
                textfield.text = playlist.name
            }
            alert.addAction(UIAlertAction(title: Constant.rename, style: .default, handler: { (action) in
                if let text = alert.textFields?.first?.text {
                    if DatabaseManager.shared.checkExistPlaylist(name: text) {
                        self.showErrorAlert(message: Constant.alreadyHave)
                    } else {
                        if DatabaseManager.shared.renamePlaylist(idPlaylist: playlist.getID(), name: text) {
                            self.view.makeToast(Constant.success)
                            self.getData()
                            self.tableView.reloadData()
                        } else {
                            self.view.makeToast(Constant.failure)
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: Constant.cancel, style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        case .delete:
            let actionYes = UIAlertAction(title: Constant.yes, style: .default) { (action) in
                if DatabaseManager.shared.deletePlaylist(idPlaylist: playlist.getID()) {
                    self.view.makeToast(Constant.success)
                    self.getData()
                    self.tableView.reloadData()
                } else {
                    self.view.makeToast(Constant.failure)
                }
            }
            let actionNo = UIAlertAction(title: Constant.no, style: .cancel, handler: nil)
            showConfirmAlert(title: Constant.confirm, message: Constant.confirmDelete, actions: [actionYes, actionNo])
        default:
            break
        }
    }
}

extension PlaylistViewController: ImageButtonDelegate {
    func handleImageButtonClicked(type: ImageButtonType) {
        if type == .back {
            navigationController?.popViewController(animated: true)
        }
    }
}
