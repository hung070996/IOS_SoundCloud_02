//
//  LibraryViewController.swift
//  SoundCloud
//
//  Created by Do Hung on 7/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {
    private struct Constant {
        static let numberOfCellInSection1 = 1
        static let numberOfCellInSection2 = 2
        static let numberOfSection = 2
        static let title = "Library"
        static let titleNone = ""
        static let titleOffline = "OFFLINE"
        static let font = "Futura"
        static let fontSize = 17
        static let heightForFooter: CGFloat = 50
        static let heightForHeader: CGFloat = 30
    }

    @IBOutlet private var titleView: TitleView!
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setTitleView()
    }
    
    func setTableView() {
        tableView.register(cellType: LibraryCell.self)
    }
    
    func setTitleView() {
        titleView.setTitle(title: Constant.title)
        titleView.setShowLeftButton(isShow: false)
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? Constant.numberOfCellInSection1 : Constant.numberOfCellInSection2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LibraryCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? Constant.titleNone : Constant.titleOffline
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.font = UIFont(name: Constant.font, size: CGFloat(Constant.fontSize))
        header.textLabel?.textColor = .black
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = tableView.backgroundColor
        view.frame.size.height = Constant.heightForFooter
        return view
    }
}
