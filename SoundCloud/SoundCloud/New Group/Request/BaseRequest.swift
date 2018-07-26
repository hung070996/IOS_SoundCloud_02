//
//  BaseRequest.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import Alamofire

enum GenreType: String {
    case allMusic = "soundcloud:genres:all-music"
    case allAudio = "soundcloud:genres:all-audio"
    case alternativeRock = "soundcloud:genres:alternativerock"
    case ambient = "soundcloud:genres:ambient"
    case classical = "soundcloud:genres:classical"
    case country = "soundcloud:genres:country"
    
    var encodedValue: String {
        return self.rawValue.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    var priority: Int {
        switch self {
        case .allMusic:
            return 0
        case .allAudio:
            return 1
        case .alternativeRock:
            return 2
        case .ambient:
            return 3
        case .classical:
            return 4
        case .country:
            return 5
        }
    }
}

class BaseRequest: NSObject {
    private var kind: String
    private var genre: GenreType
    private var clientID: String
    private var limit: Int
    private struct DefaultValue {
        static let defaultKind = "top"
        static let defaultClientID = APIKey.clientID
        static let defaultLimit = 20
        static let defaultGenre = GenreType.allMusic
    }
    
    override init() {
        kind = DefaultValue.defaultKind
        clientID = DefaultValue.defaultClientID
        limit = DefaultValue.defaultLimit
        self.genre = DefaultValue.defaultGenre
    }
    
    convenience init(genre: GenreType) {
        self.init()
        self.genre = genre
    }
    
    init(kind: String, genre: GenreType, clientID: String, limit: Int) {
        self.kind = kind
        self.genre = genre
        self.clientID = clientID
        self.limit = limit
    }
    
    func getParameter() -> Parameters {
        return [
            APIParameterKey.kind: kind,
            APIParameterKey.genre: genre.encodedValue,
            APIParameterKey.limit: limit,
            APIParameterKey.client_id: clientID
        ]
    }
}
