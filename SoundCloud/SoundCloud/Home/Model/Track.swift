//
//  Track.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import ObjectMapper

class Track: Mappable {
    var id = 0
    var name = ""
    var genre = ""
    var urlImage = ""
    var createdAt = ""
    var des = ""
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
    var artist = ""
    
    init() {}
    
    init(id: Int, name: String, genre: String,
         urlImage: String, createdAt: String, description: String,
         downloadable: Bool, downloadUrl: String, duration: Int,
        fullDuration: Int, kind: String, permalinkUrl: String,
        streamable: Bool, title: String, uri: String,
        urn: String, waveformUrl: String, artist: String) {
        self.id = id
        self.name = name
        self.genre = genre
        self.urlImage = urlImage
        self.createdAt = createdAt
        self.des = description
        self.downloadable = downloadable
        self.downloadUrl = downloadUrl
        self.duration = duration
        self.fullDuration = fullDuration
        self.kind = kind
        self.permalinkUrl = permalinkUrl
        self.streamable = streamable
        self.title = title
        self.uri = uri
        self.urn = urn
        self.waveformUrl = waveformUrl
        self.artist = artist
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["track.id"]
        name <- map["track.label_name"]
        genre <- map["track.genre"]
        urlImage <- map["track.artwork_url"]
        createdAt <- map["track.created_at"]
        des <- map["track.description"]
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
        artist <- map["track.publisher_metadata.artist"]
    }
    
    func getID() -> Int { return self.id }
}
