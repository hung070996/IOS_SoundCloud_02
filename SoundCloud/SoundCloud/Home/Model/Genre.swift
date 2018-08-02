//
//  Genre.swift
//  SoundCloud
//
//  Created by Do Hung on 7/26/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import ObjectMapper

enum GenreType: Int {
    private struct Constant {
        static let allMusic = "All Music"
        static let allAudio = "All Audio"
        static let alternativerock = "Alternativerock"
        static let ambient = "Ambient"
        static let classical = "Classical"
        static let country = "Country"
        static let allMusicServer = "soundcloud:genres:all-music"
        static let allAudioServer = "soundcloud:genres:all-audio"
        static let alternativerockServer = "soundcloud:genres:alternativerock"
        static let ambientServer = "soundcloud:genres:ambient"
        static let classicalServer = "soundcloud:genres:classical"
        static let countryServer = "soundcloud:genres:country"
    }
    
    case allMusic = 0, allAudio, alternativeRock, ambient, classical, country
    
    var encodedValue: String {
        return self.getString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    var getNameType: String {
        switch self {
        case .allMusic:
            return Constant.allMusic
            
        case .allAudio:
            return Constant.allAudio
            
        case .alternativeRock:
            return Constant.alternativerock
            
        case .ambient:
            return Constant.ambient
            
        case .classical:
            return Constant.classical
            
        case .country:
            return Constant.country
        }
    }
    
    var getString: String {
        switch self {
        case .allMusic:
            return Constant.allMusicServer
            
        case .allAudio:
            return Constant.allAudioServer
            
        case .alternativeRock:
            return Constant.alternativerockServer
            
        case .ambient:
            return Constant.ambientServer
            
        case .classical:
            return Constant.classicalServer
            
        case .country:
            return Constant.countryServer
        }
    }
}

class Genre: Mappable {
    private struct Constant {
        static let allMusic = "soundcloud:genres:all-music"
        static let allAudio = "soundcloud:genres:all-audio"
        static let alternativerock = "soundcloud:genres:alternativerock"
        static let ambient = "soundcloud:genres:ambient"
        static let classical = "soundcloud:genres:classical"
        static let country = "soundcloud:genres:country"
    }
    
    var collection = [Track]()
    var genreType = GenreType.allMusic
    var name: String? {
        didSet {
            guard let name = name else {
                genreType = .allMusic
                return
            }
            switch name {
            case Constant.allMusic:
                genreType = .allMusic
                
            case Constant.allAudio:
                genreType = .allAudio
                
            case Constant.alternativerock:
                genreType = .alternativeRock
                
            case Constant.ambient:
                genreType = .ambient
                
            case Constant.classical:
                genreType = .classical
                
            case Constant.country:
                genreType = .country
                
            default:
                break
            }
        }
    }
    
    init() {}
    
    init(type: GenreType) {
        self.genreType = type
    }
    
    func setCollection(collection: [Track]) {
        self.collection = collection
    }
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["genre"]
        collection <- map["collection"]
    }
}
