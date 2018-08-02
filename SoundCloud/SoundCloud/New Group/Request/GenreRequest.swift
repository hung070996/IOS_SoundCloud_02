//
//  GenreRequest.swift
//  SoundCloud
//
//  Created by Do Hung on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Alamofire

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
    
    convenience init(genre: GenreType, limit: Int) {
        self.init()
        self.genre = genre
        self.limit = limit
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
