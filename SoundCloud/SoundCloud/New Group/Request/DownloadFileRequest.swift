//
//  DownloadFileRequest.swift
//  SoundCloud
//
//  Created by Do Hung on 7/30/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Alamofire

class DownloadFileRequest: BaseRequest {
    var clientID = ""
    
    init() {
        clientID = APIKey.clientID
    }
    
    func getParameter() -> Parameters {
        return [APIParameterKey.client_id: clientID]
    }
}
