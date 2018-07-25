//
//  Track.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import ObjectMapper

final class Track: Mappable {
    var id: Int?
    var name: String?
    var genre: String?
    var downloadable: Bool?
    var urlImage: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["track.id"]
        name <- map["track.label_name"]
        genre <- map["track.genre"]
        downloadable <- map["track.downloadable"]
        urlImage <- map["track.artwork_url"]
    }
}
