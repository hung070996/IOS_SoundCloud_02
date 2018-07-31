//
//  Constants.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation

struct BaseUrl {
    static let general = "https://api-v2.soundcloud.com/charts"
    static let search = "https://api-v2.soundcloud.com/search/tracks"
    
    static func baseUrl(track: Track) -> String {
        return "http://api.soundcloud.com/tracks/\(track.id)/stream"
    }
}

struct APIParameterKey {
    static let kind = "kind"
    static let genre = "genre"
    static let client_id = "client_id"
    static let limit = "limit"
    static let keySearch = "q"
}
