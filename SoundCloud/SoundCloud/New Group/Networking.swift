//
//  Networking.swift
//  SoundCloud
//
//  Created by Do Hung on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation

class Networking {
    static func getGenres(listGenre: [GenreType], completion: @escaping (_ result: [Genre]?, _ error: BaseError?) -> Void) {
        var arrGenre = [Genre]()
        for type in listGenre {
            let request = GenreRequest(genre: type)
            APIManager.shared.request(input: request) { (result: Genre?, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    guard let result = result else {
                        return
                    }
                    arrGenre.append(result)
                    if arrGenre.count == listGenre.count {
                        completion(arrGenre, nil)
                    }
                }
            }
        }
    }
    
    static func getSearch(key: String, completion: @escaping (_ result: SearchResponse?, _ error: BaseError?) -> Void) {
        let request = SearchRequest(key: key)
        APIManager.shared.request(input: request) { (result: SearchResponse?, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(result, nil)
            }
        }
    }
}
