//
//  SearchResponse.swift
//  SoundCloud
//
//  Created by Do Hung on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchResponse: Mappable {
    var total = 0
    var collection = [TrackSearch]()
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        total <- map["total_results"]
        collection <- map["collection"]
    }
}
