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
    var id = 0
    var name = ""
    var genre = ""
    var urlImage = ""
    var createdAt = ""
    var description = ""
    var downloadable = false
    var downloadUrl = ""
    var duration = 0
    var fullDuration = 0
    var kind = ""
    var permalinkUrl = ""
    var streamable = false
    var title = ""
    var uri = ""
    var urn = ""
    var waveformUrl = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["track.id"]
        name <- map["track.label_name"]
        genre <- map["track.genre"]
        urlImage <- map["track.artwork_url"]
        createdAt <- map["track.created_at"]
        description <- map["track.description"]
        downloadable <- map["track.downloadable"]
        downloadUrl <- map["track.download_url"]
        duration <- map["track.duration"]
        fullDuration <- map["track.full_duration"]
        kind <- map["track.kind"]
        permalinkUrl <- map["track.permalink_url"]
        streamable <- map["track.streamable"]
        title <- map["track.title"]
        uri <- map["track.uri"]
        urn <- map["track.urn"]
        waveformUrl <- map["track.waveform_url"]
    }
}
