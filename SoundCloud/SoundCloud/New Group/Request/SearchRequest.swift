//
//  SearchRequest.swift
//  SoundCloud
//
//  Created by Do Hung on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Alamofire

class SearchRequest: BaseRequest {
    var keySearch = ""
    var clientID = ""
    var limit = 0
    
    init() {
        keySearch = ""
        clientID = APIKey.clientID
        limit = 20
    }
    
    convenience init(key: String) {
        self.init()
        keySearch = key
    }
    
    func getParameter() -> Parameters {
        return [
            APIParameterKey.keySearch: keySearch,
            APIParameterKey.client_id: clientID,
            APIParameterKey.limit: limit
        ]
    }
}
