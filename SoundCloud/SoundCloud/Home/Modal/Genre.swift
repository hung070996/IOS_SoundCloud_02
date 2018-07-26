//
//  Genre.swift
//  SoundCloud
//
//  Created by Do Hung on 7/26/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import ObjectMapper

class Genre: Mappable {
    private struct Constant {
        static let allMusic = "All Music"
        static let allAudio = "All Audio"
        static let alternativerock = "Alternativerock"
        static let ambient = "Ambient"
        static let classical = "Classical"
        static let country = "Country"
    }
    
    var genre = GenreType.allMusic
    var name = ""
    var collection = [Track]()
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        genre <- map["genre"]
        collection <- map["collection"]
        switch genre {
        case .allMusic:
            name = Constant.allMusic
        case .allAudio:
            name = Constant.allAudio
        case .alternativeRock:
            name = Constant.alternativerock
        case .ambient:
            name = Constant.ambient
        case .classical:
            name = Constant.classical
        case .country:
            name = Constant.country
        }
    }
}
