//
//  BaseAPIRouter.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseAPIRouter: URLRequestConvertible {
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var path: String { get }
    var parameterEncoding: ParameterEncoding { get }
}
