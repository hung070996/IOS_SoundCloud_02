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
        name <- map["genre"]
        switch name {
        case GenreType.allMusic.getString:
            genre = GenreType.allMusic
            name = Constant.allMusic
        case GenreType.allAudio.getString:
            genre = GenreType.allAudio
            name = Constant.allAudio
        case GenreType.alternativeRock.getString:
            genre = GenreType.alternativeRock
            name = Constant.alternativerock
        case GenreType.ambient.getString:
            genre = GenreType.ambient
            name = Constant.ambient
        case GenreType.classical.getString:
            genre = GenreType.classical
            name = Constant.classical
        case GenreType.country.getString:
            genre = GenreType.country
            name = Constant.country
        default:
            break
        }
        collection <- map["collection"]
    }
}
