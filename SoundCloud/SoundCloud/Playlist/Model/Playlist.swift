//
//  Playlist.swift
//  SoundCloud
//
//  Created by Do Hung on 7/31/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class Playlist: NSObject {
    var id = 0
    var name = ""
    var listTrack = [Track]()
    
    override init() {}
    
    init(id: Int, name: String, list: [Track]) {
        self.id = id
        self.name = name
        self.listTrack = list
    }
}
