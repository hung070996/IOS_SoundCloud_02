//
//  Container.swift
//  SoundCloud
//
//  Created by Do Hung on 7/31/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class Container: NSObject {
    var idSong = 0
    var idPlaylist = 0
    
    init(idSong: Int, idPlaylist: Int) {
        self.idSong = idSong
        self.idPlaylist = idPlaylist
    }
}
