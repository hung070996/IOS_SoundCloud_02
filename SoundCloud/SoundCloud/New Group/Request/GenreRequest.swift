//
//  GenreRequest.swift
//  SoundCloud
//
//  Created by Do Hung on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Alamofire

enum GenreType: Int {
    case allMusic = 0, allAudio, alternativeRock, ambient, classical, country
    
    var encodedValue: String {
        return self.getString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    var getString: String {
        switch self {
        case .allMusic:
            return "soundcloud:genres:all-music"
        case .allAudio:
            return "soundcloud:genres:all-audio"
        case .alternativeRock:
            return "soundcloud:genres:alternativerock"
        case .ambient:
            return "soundcloud:genres:ambient"
        case .classical:
            return "soundcloud:genres:classical"
        case .country:
            return "soundcloud:genres:country"
        }
    }
}

class GenreRequest: BaseRequest {
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
    
    init() {
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
