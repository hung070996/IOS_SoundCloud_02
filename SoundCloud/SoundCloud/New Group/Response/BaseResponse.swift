//
//  BaseResponse.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse: Mappable {
    var genre: String?
    var kind: String?
    var lastUpdated: String?
    var listTrack: [Track]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        genre <- map["genre"]
        kind <- map["kind"]
        lastUpdated <- map["last_updated"]
        listTrack <- map["collection"]
    }
}
