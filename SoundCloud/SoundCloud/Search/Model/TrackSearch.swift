//
//  TrackSearch.swift
//  SoundCloud
//
//  Created by Do Hung on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import ObjectMapper

class TrackSearch: Track {
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["label_name"]
        genre <- map["genre"]
        urlImage <- map["artwork_url"]
        createdAt <- map["created_at"]
        des <- map["description"]
        downloadable <- map["downloadable"]
        downloadUrl <- map["download_url"]
        duration <- map["duration"]
        fullDuration <- map["full_duration"]
        kind <- map["kind"]
        permalinkUrl <- map["permalink_url"]
        streamable <- map["streamable"]
        title <- map["title"]
        uri <- map["uri"]
        urn <- map["urn"]
        waveformUrl <- map["waveform_url"]
        artist <- map["publisher_metadata.artist"]
    }
}
