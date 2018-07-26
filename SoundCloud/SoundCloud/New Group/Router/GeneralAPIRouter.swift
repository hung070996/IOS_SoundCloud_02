//
//  GeneralAPIRouter.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import Alamofire

enum GeneralAPIRouter: BaseAPIRouter {
    
    case getTrack(request: BaseRequest)
    
    var headers: HTTPHeaders {
        switch self {
        default:
            return [:]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .getTrack(request):
            return request.getParameter()
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var path: String {
        switch self {
        case .getTrack(_):
            return BaseUrl.general
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return try parameterEncoding.encode(urlRequest, with: parameters)
    }
}
