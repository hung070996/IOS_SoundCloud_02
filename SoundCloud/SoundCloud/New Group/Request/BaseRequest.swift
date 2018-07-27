//
//  BaseRequest.swift
//  SoundCloud
//
//  Created by Do Hung on 7/27/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Alamofire

protocol BaseRequest {
    func getParameter() -> Parameters
}
